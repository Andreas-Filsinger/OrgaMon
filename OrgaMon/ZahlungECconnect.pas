{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
}
unit ZahlungECconnect;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls,
  ComCtrls, WordIndex, Buttons;

type
  TFormZahlungECconnect = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_BLZ: TEdit;
    Edit_Konto: TEdit;
    Edit_GueltigBis: TEdit;
    StaticText1: TStaticText;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    StaticText2: TStaticText;
    Edit5: TEdit;
    Button4: TButton;
    Label8: TLabel;
    Edit6: TEdit;
    SpeedButton4: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit7: TEdit;
    Edit8: TEdit;
    Button11: TButton;
    Image1: TImage;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button3: TButton;
    Button5: TButton;
    SpeedButton3: TSpeedButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Click(Sender: TObject);
    procedure Edit7Click(Sender: TObject);
  private

    { Private-Deklarationen }
    KeyCaptureMode: boolean;
    sKeyLog: TStringList;
    LastCard: string;
    LastschriftFName: string;
    Betrag: double;
    BELEG_R: integer;
    VerwendungsZweck: string;
    Name1, Name2: string;

    function _blz: string;
    function _konto: string;
    function _gueltig: string;
    function _name: string;

  public

    PERSON_R: integer;
    DatenKommenVonDerKarte: boolean;

    { Public-Deklarationen }
    procedure Log(s: string);
    procedure clearContext;
    procedure setPERSON_R(RID: integer);

    procedure loadFromCard;
    procedure fillContext;

    procedure setTestdata;
    procedure doActivate(active: boolean);
    procedure createDocument;
    procedure showDocument;
    procedure hotEvent;

  end;

var
  FormZahlungECconnect: TFormZahlungECconnect;

implementation

uses
  anfix32, globals,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Buch,
  Funktionen_Auftrag,
  Bearbeiter,
  html, Person,
  Belege, Datenbank, Main,
  dbOrgaMon, SysHot,
  wanfix32, gplists, geld,
  Kontext;
{$R *.dfm}

const
  cLightGreen = $CCFFCC;
  cLightRed = $FF9933;

procedure TFormZahlungECconnect.Button11Click(Sender: TObject);
var
  sSQL: string;
begin
  repeat

    // Keine Person gesetzt
    if (PERSON_R < cRID_FirstValid) then
      break;

    // Warnung, wenn die Karte gar nicht gelesen werden
    // konnte UND die Daten bereits aus einer letzten
    // Zahlung kamen.
    if not(DatenKommenVonDerKarte) then
      if not(Doit('Die Daten kommen nicht von der Karte! Dennoch buchen')) then
        break;

    // SQL bilden
    sSQL := 'update PERSON set' +
    { } ' Z_ELV_KONTO_INHABER=''' + _name + ''', ' +
    { } ' Z_ELV_BLZ=''' + Edit_BLZ.text + ''', ' +
    { } ' Z_ELV_KONTO=''' + Bank_Konto(Edit_Konto.text) + ''', ' +
    { } ' Z_ELV_FREIGABE=coalesce(Z_ELV_FREIGABE,0.0) + ' + FloatToStrISO(Betrag, 2) + ' ' +
    { } 'where' +
    { } ' RID=' + inttostr(PERSON_R);

    // Log
    AppendStringsToFile(
      { } datum + cOLAPcsvSeparator +
      { } uhr8 + cOLAPcsvSeparator +
      { } FormBearbeiter.sBearbeiterKurz + cOLAPcsvSeparator +
      { } ComputerName + cOLAPcsvSeparator +
      { } sSQL,
      { } DiagnosePath + 'Zahlung.POZ.log.txt');

    // Kontodaten übertragen, EC-Freigabe geben!
    e_x_sql(sSQL);

    // Ev. verhindern dass mehrfach gebucht wird!
    DatenKommenVonDerKarte := false;

    // Fenster schliessen!
    close;

  until true;
end;

procedure TFormZahlungECconnect.Button1Click(Sender: TObject);
begin
  if assigned(sKeyLog) then
  begin
    sKeyLog.SaveToFile(DiagnosePath + 'Magneto.log.txt');
    openShell(DiagnosePath + 'Magneto.log.txt');
  end;
end;

procedure TFormZahlungECconnect.Button3Click(Sender: TObject);
begin
  FormPerson.setContext(PERSON_R);
end;

procedure TFormZahlungECconnect.Button4Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'Zahlung.POZ.log.txt');
end;

procedure TFormZahlungECconnect.Button5Click(Sender: TObject);
begin
  // Beleg neu erstellen
  createDocument;
  if (LastschriftFName <> '') then
    openShell(LastschriftFName);
end;

procedure TFormZahlungECconnect.CheckBox1Click(Sender: TObject);
begin
  doActivate(CheckBox1.Checked);
end;

procedure TFormZahlungECconnect.clearContext;
begin

  // Context-Sachen
  setPERSON_R(cRID_null);
  Betrag := 0.0;
  BELEG_R := cRID_null;
  LastschriftFName := '';
  DatenKommenVonDerKarte := false;

  // Karten Daten
  Edit_BLZ.text := '';
  StaticText1.caption := '';
  Edit_Konto.text := '';
  Edit_GueltigBis.text := '';

  // Personen und Zahlungsdaten
  Edit4.text := '';
  Edit5.text := '';
  StaticText2.caption := '0,00 €';
  StaticText2.color := clBtnFace;

end;

procedure TFormZahlungECconnect.createDocument;
var
  BelegInfo: TStringList;
  sELV_Option: TStringList;
begin
  if (PERSON_R >= cRID_FirstValid) then
  begin

    Name1 := e_r_KontoInhaber(PERSON_R);
    Name2 := e_r_VornameNachname(PERSON_R);

    sELV_Option := TStringList.create;
    with sELV_Option do
    begin
      add('template=Lastschrift.html');
      add('aktuell=' + cIni_Activate);
      add('mahngebühr=' + cIni_DeActivate);
      add('ohneAusstehende=' + cIni_Activate);
      add('nurEinBeleg=' + cIni_Activate);
      add('ELV_KontoNummer=' + Bank_Konto(Edit_Konto.text));
      add('ELV_BLZ=' + Edit_BLZ.text);
      add('ELV_Bank=' + StaticText1.caption);
      add('ELV_KontoInhaber=' + _name);
    end;

    // Person gefunden!
    BelegInfo := e_w_KontoInfo(PERSON_R, sELV_Option);
    Betrag := strtodoubledef(BelegInfo.values['OFFEN'], 0);
    BELEG_R := strtointdef(BelegInfo.values['BELEGE'], cRID_Null);
    LastschriftFName := BelegInfo.values['OUT'];
    VerwendungsZweck := BelegInfo.values['RECHNUNGEN'];

    BelegInfo.free;
    sELV_Option.free;
  end
  else
  begin
    LastschriftFName := '';
  end;
end;

procedure TFormZahlungECconnect.doActivate(active: boolean);
begin
  FormMain.registerHot('EC-Karte', [], vkF2, active);
  if active <> CheckBox1.Checked then
    CheckBox1.Checked := active;
end;

procedure TFormZahlungECconnect.Edit4Click(Sender: TObject);
begin
  RadioButton3.Checked := false;
  RadioButton2.Checked := false;
  RadioButton1.Checked := true;
end;

procedure TFormZahlungECconnect.Edit7Click(Sender: TObject);
begin
  RadioButton3.Checked := false;
  RadioButton1.Checked := false;
  RadioButton2.Checked := true;
end;

procedure TFormZahlungECconnect.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  if not(RadioButton3.Checked) then
    RadioButton3.Checked := true;
end;

procedure TFormZahlungECconnect.FormActivate(Sender: TObject);
begin
  setPERSON_R(PERSON_R);
end;

procedure TFormZahlungECconnect.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormZahlungECconnect.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if KeyCaptureMode then
  begin
    Log(inttostr(ord(Key)) + ' : "' + Key + '"');
    LastCard := LastCard + Key;
    Key := #0;
    if (pos('</3>', LastCard) > 0) then
    begin
      KeyCaptureMode := false;

      AppendStringsToFile(
        { } datum + cOLAPcsvSeparator +
        { } uhr8 + cOLAPcsvSeparator +
        { } FormBearbeiter.sBearbeiterKurz + cOLAPcsvSeparator +
        { } ComputerName + cOLAPcsvSeparator +
        { } LastCard,
        { } DiagnosePath + 'Zahlung.POZ.log.txt');

      loadFromCard;

      fillContext;
    end;
  end;
end;

procedure TFormZahlungECconnect.hotEvent;
begin
  clearContext;
  if assigned(sKeyLog) then
    sKeyLog.Clear;
  KeyCaptureMode := true;
  LastCard := '';
  show;
  setfocus;
  PageControl1.ActivePage := TabSheet1;
  SetForegroundWindow(handle);
end;

procedure TFormZahlungECconnect.loadFromCard;
begin
  Edit_BLZ.text := _blz;
  Edit_Konto.text := _konto;
  Edit_GueltigBis.text := _gueltig;
  DatenKommenVonDerKarte := true;
end;

procedure TFormZahlungECconnect.Log(s: string);
begin
  //
  if not(assigned(sKeyLog)) then
    sKeyLog := TStringList.create;
  sKeyLog.add(s);
end;

procedure TFormZahlungECconnect.RadioButton1Click(Sender: TObject);
begin
  showDocument;
end;

procedure TFormZahlungECconnect.showDocument;
begin
  Edit4.text := Name1;
  Edit7.text := Name2;
  Edit5.text := VerwendungsZweck;
  StaticText2.caption := format('%m', [abs(Betrag)]);
  if (Betrag > 0.01) then
    StaticText2.color := clred
  else
    StaticText2.color := cllime;
  if (PERSON_R >= cRID_FirstValid) then
  begin
    repeat
      if RadioButton1.Checked then
      begin
        Edit4.color := HTMLColor2TColor(cLightGreen);
        Edit7.color := clWindow;
        Edit8.color := clWindow;
        break;
      end;
      if RadioButton2.Checked then
      begin
        Edit4.color := clWindow;
        Edit7.color := HTMLColor2TColor(cLightGreen);
        Edit8.color := clWindow;
        break;
      end;
      if RadioButton3.Checked then
      begin
        Edit4.color := clWindow;
        Edit7.color := clWindow;
        Edit8.color := HTMLColor2TColor(cLightGreen);
        break;
      end;
    until true;
  end
  else
  begin
    Edit4.color := HTMLColor2TColor(cLightRed);
    Edit7.color := clWindow;
    Edit8.color := clWindow;
  end;
end;

procedure TFormZahlungECconnect.fillContext;
var
  lPERSON: TgpIntegerList;
  KONTO_PERSON_R: integer;
  n: integer;
begin
  BeginHourGlass;

  // BLZ in Bankname umsetzen prüfen
  StaticText1.caption := getBank(Edit_BLZ.text);
  Edit8.text := '';

  // Person dazu ermitteln!
  lPERSON := e_r_Person_BLZ_Konto(
    { } Edit_BLZ.text,
    { } Bank_Konto(Edit_Konto.text));

  KONTO_PERSON_R := cRID_null;
  repeat

    // nix gefunden
    if (lPERSON.count = 0) then
      break;

    // genau einer gefunden
    if (lPERSON.count = 1) then
    begin
      KONTO_PERSON_R := lPERSON[0];
      break;
    end;

    // mehrere gefunden, den wählen der überhaupt eine Forderung offen hat
    KONTO_PERSON_R := cRID_null;
    for n := 0 to pred(lPERSON.count) do
      if (isSomeMoney(b_r_PersonSaldo(lPERSON[n]))) then
      begin
        KONTO_PERSON_R := lPERSON[n];
        break;
      end;
    if (KONTO_PERSON_R <> cRID_null) then
      break;

    // halt den aktuellsten nehmen!
    KONTO_PERSON_R := FormKontext.cnPERSON.top;

  until true;
  lPERSON.free;

  setPERSON_R(KONTO_PERSON_R);

  //
  createDocument;

  //
  RadioButton3.Checked := false;
  RadioButton2.Checked := false;
  RadioButton1.Checked := true;

  showDocument;

  EndHourGlass;
end;

procedure TFormZahlungECconnect.setPERSON_R(RID: integer);
begin
  PERSON_R := RID;
  if (PERSON_R >= cRID_FirstValid) then
  begin
    Button11.enabled := true;
    Button3.enabled := true;
    Button5.enabled := true;
    SpeedButton2.enabled := true;
  end
  else
  begin
    Button11.enabled := false;
    Button3.enabled := false;
    Button5.enabled := false;
    SpeedButton2.enabled := false;
  end;
end;

procedure TFormZahlungECconnect.setTestdata;
begin
  //
  if (Edit6.text <> '') then
  begin
    LastCard := Edit6.text;
    loadFromCard;
    fillContext;
  end;
end;

procedure TFormZahlungECconnect.SpeedButton2Click(Sender: TObject);
begin
  createDocument;
  if (LastschriftFName <> '') then
    wanfix32.printShell(LastschriftFName);
end;

procedure TFormZahlungECconnect.SpeedButton3Click(Sender: TObject);
var
  p, p1, p2: integer;
begin
  p := 0;
  p1 := FormBelege.getContext_PERSON_R;
  p2 := FormPerson.getContext;
  repeat

    repeat

      if (p1 <> p2) and (p1 > 0) and (p2 > 0) then
      begin
        if Doit('OK:' + #13 + e_r_Person(p1) + #13 + #13 + 'Abbrechen:' + #13 + e_r_Person(p2) + #13
          + #13 + 'Welche Person soll eingesetzt werden') then
          p := p1
        else
          p := p2;
        setPERSON_R(p);
        break;
      end;

      if (p1 <= 0) and (p2 > 0) then
      begin
        p := p2;
        break;
      end;

      p := p1;

    until true;

    if (p > 0) then
    begin

      // Nachfrage
      if (PERSON_R >= cRID_FirstValid) and (PERSON_R <> p) then
        if not(Doit('Soll wirklich eine andere Person eingesetzt werden?')) then
          break;

      // neue Person eintragen ...
      setPERSON_R(p);

      //
      createDocument;
      showDocument;

    end;

  until true;
end;

procedure TFormZahlungECconnect.SpeedButton4Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
  setTestdata;
end;

procedure TFormZahlungECconnect.SpeedButton5Click(Sender: TObject);
begin
  fillContext;
end;

function TFormZahlungECconnect._blz: string;
begin
  result := ExtractSegmentBetween(LastCard, '<3>', '</3>');
  result := nextp(result, '=', 0);
  result := copy(result, succ(length(result) - 8), 8);
end;

function TFormZahlungECconnect._gueltig: string;
begin
  result := ExtractSegmentBetween(LastCard, '<2>', '</2>');
  result := nextp(result, '=', 1);
  result := copy(result, 1, 4);
  result := '31.' + copy(result, 3, 2) + '.' + copy(result, 1, 2);
  result := long2date(date2long(result));
end;

function TFormZahlungECconnect._konto: string;
begin
  result := ExtractSegmentBetween(LastCard, '<3>', '</3>');
  result := nextp(result, '=', 1);
  result := copy(result, 1, length(result) - 1);
end;

function TFormZahlungECconnect._name: string;
begin
  result := '';
  if RadioButton1.Checked then
    result := Edit4.text;
  if RadioButton2.Checked then
    result := Edit7.text;
  if RadioButton3.Checked then
    result := Edit8.text;
end;

end.
