{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016 Andreas Filsinger
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
unit AuftragMobil;
//
// Ausgabe der Auftrags-Daten ins InterNet
// Auslesen der Ergebnis-Daten ins InterNet
//

interface

uses
  Windows, Messages, SysUtils,
  Buttons, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,

  // IBO
  IB_Components, IB_Access,

  // Indy
  IdFTP;

type
  TFormAuftragMobil = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Memo1: TMemo;
    Button2: TButton;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    ProgressBar1: TProgressBar;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Button4: TButton;
    ComboBox2: TComboBox;
    Button5: TButton;
    Label1: TLabel;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    SpeedButton2: TSpeedButton;
    Button3: TButton;
    CheckBox2: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    Button7: TButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;
    IdFTP1: TIdFTP;

    procedure RefreshGeraeteAuswahl;
    procedure Log(s: string);

  public
    { Public-Deklarationen }

    // Neuigkeiten der Monteure vom InterNet downloaden, und in die
    // Datenbank einlesen
    function ReadMobil: boolean;

    // Terminplanungen aus der Datenbank in das Mobil-Format
    // bringen und ins InterNet uploaden
    function WriteMobil: boolean;

  end;

var
  FormAuftragMobil: TFormAuftragMobil;

implementation

uses
  // anfix tools
  globals, anfix32, gplists,
  html, SolidFTP, dbOrgaMon,
  CareTakerClient, wanfix32, WordIndex,

  // OrgaMon tools
  Datenbank, AuftragArbeitsplatz, JonDaExec,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag;

{$R *.dfm}

function TFormAuftragMobil.WriteMobil: boolean;
var
  ActionCount: integer;
  BerichtL: TStringList;
  LastTime: dword;
  DatumsL: TgpIntegerList;
  EinMonteurL: TgpIntegerList;
  n: integer;
  IndexH: THTMLTemplate;
  Monteur: string;
  LastGeraeteNo: string;
  GeraeteNo: string;
  ErrorCount: integer;
  _Datum: TAnfixDate;
  CloseLater: boolean;
  JONDA_TAN: integer;
  cPERSON: TIB_Cursor;
  lAbgearbeitet: TgpIntegerList;
  lAbgezogen: TgpIntegerList;
  lMonteure: TgpIntegerList;
  PERSON_R: integer;
  FTPup: TStringList;
  sMONTEUR_R: string;
  MONTEUR_R: integer;

  procedure ShowStep;
  begin
    inc(ActionCount);
    if frequently(LastTime, 333) then
    begin
      application.ProcessMessages;
      ProgressBar1.Position := ActionCount;
    end;
  end;

  procedure doFTPup;
  var
    lUeberzaehligeGeraete: TStringList;
    n, k: integer;
  begin

    lUeberzaehligeGeraete := TStringList.create;
    //
    Label3.caption := 'FTP-Upload ...';
    application.ProcessMessages;
    SolidFTP_Retries := 200;

    SolidInit(IdFTP1);
    with IdFTP1 do
    begin
      Host := nextp(iMobilFTP, ';', 0);
      UserName := nextp(iMobilFTP, ';', 1);
      Password := nextp(iMobilFTP, ';', 2);
    end;
    if CheckBox7.Checked then
      with IdFTP1 do
      begin
        // Test Zugangsdaten
        Host := cFTP_Host;
        UserName := cFTP_UserName;
        Password := cFTP_Password;
      end;

    //
    repeat

      // alle alten ???.DAT löschen!
      if CheckBox8.Checked then
        if (lMonteure.count = 0) then
        begin

          //
          if not(SolidDir(IdFTP1, '', '*.DAT', '???.DAT', lUeberzaehligeGeraete)) then
          begin
            Log(cERRORText + ' ' + SolidFTP_LastError);
            break;
          end;
          lUeberzaehligeGeraete.sort;

          // die heute übertragenen Schützen, alles andere löschen!
          for n := 0 to pred(FTPup.count) do
          begin
            k := lUeberzaehligeGeraete.indexof(nextp(FTPup[n], ';', 2));
            if (k <> -1) then
              lUeberzaehligeGeraete.delete(k);
          end;

        end;

      //
      if not(SolidPut(IdFTP1, FTPup)) then
      begin
        Log(cERRORText + ' ' + SolidFTP_LastError);
        break;
      end;

      //
      if CheckBox8.Checked then
        if not(SolidDel(IdFTP1, '', lUeberzaehligeGeraete)) then
        begin
          Log(cERRORText + ' ' + SolidFTP_LastError);
          break;
        end;
      try
        IdFTP1.Disconnect;
      except
      end;
    until true;

    if assigned(SolidFTP_sLog) then
      if (SolidFTP_sLog.count > 0) then
        SolidFTP_sLog.SaveToFile(DiagnosePath + 'FTP_up_' + inttostrN(JONDA_TAN, 6) + '.log.txt');

    lUeberzaehligeGeraete.free;
  end;

begin
  result := true;

  if not(FileExists(HtmlVorlagenPath + 'MonDa_Index.html')) then
    exit;

  BeginHourGlass;

  JONDA_TAN := e_w_gen('GEN_JONDA');

  //
  CloseLater := false;
  if not(Active) then
  begin
    show;
    CloseLater := true;
  end;

  //
  Label3.caption := 'Vorlauf ...';
  application.ProcessMessages;

  ErrorCount := 0;

  BerichtL := TStringList.create;
  FTPup := TStringList.create;

  IndexH := THTMLTemplate.create;
  DatumsL := TgpIntegerList.create;
  EinMonteurL := TgpIntegerList.create;
  cPERSON := DataModuleDatenbank.nCursor;
  lAbgearbeitet := TgpIntegerList.create;
  lMonteure := TgpIntegerList.create;

  ActionCount := 0;
  LastTime := 0;
  for n := 0 to pred(JonDaVorlauf) do
    DatumsL.add(DatePlus(DateGet, n));
  FileDelete(MdePath + 'MonDa*.html');
  InvalidateCache_Monteur;

  for n := 0 to pred(Memo1.lines.count) do
  begin
    PERSON_R := e_r_MonteurRIDFromKuerzel(nextp(Memo1.lines[n], ',', 0));
    if (PERSON_R > 0) then
      lMonteure.add(PERSON_R);
  end;

  if CheckBox12.Checked then
  begin
    // JonDa-Server über die Baustellen informieren
    Label3.caption := 'Baustellen-Infos ...';
    application.ProcessMessages;
    e_r_Sync_Baustelle;
    FTPup.add(MdePath + cFotoService_BaustelleFName + ';' + ';' + cFotoService_BaustelleFName);
  end;

  // MonDa-Server über abgearbeitete informieren
  if CheckBox9.Checked then
  begin
    Label3.caption := 'Abgearbeitete ...';
    application.ProcessMessages;
    lAbgearbeitet := e_r_sqlm(
      { } 'select AUFTRAG.RID from AUFTRAG ' +
      { } 'join BAUSTELLE on ' +
      { } ' (BAUSTELLE.RID=AUFTRAG.BAUSTELLE_R) and' +
      { } ' (BAUSTELLE.EXPORT_MONDA=''' + cC_True + ''')' +
      { } 'where' +
      { } ' (AUFTRAG.STATUS in (' +
      { } inttostr(cs_Erfolg) + ',' +
      { } inttostr(cs_NeuAnschreiben) + ',' +
      { } inttostr(cs_Vorgezogen) + ',' +
      { } inttostr(cs_Unmoeglich) + '))');
    lAbgearbeitet.SaveToFile(MdePath + 'abgearbeitet.dat');
    FTPup.add(MdePath + 'abgearbeitet.dat' + ';' + ';' + 'abgearbeitet.dat');
  end;

  with cPERSON, IndexH do
  begin
    // alle Monteure mit Geräten ...
    sql.add('SELECT');
    sql.add(' person.RID,');
    sql.add(' person.MONDA,');
    sql.add(' anschrift.NAME1');
    sql.add('FROM');
    sql.add(' PERSON');
    sql.add('join');
    sql.add(' anschrift');
    sql.add('on');
    sql.add(' person.priv_anschrift_r=anschrift.rid');
    sql.add('WHERE');
    if (lMonteure.count > 0) then
      sql.add(' (person.rid in ' + ListasSQL(lMonteure) + ') AND');
    sql.add(' (person.MONDA IS NOT NULL) AND');
    sql.add(' (person.MONDA<>'''')');
    sql.add('ORDER BY');
    sql.add(' person.MONDA,person.KUERZEL');

    //
    LoadFromFile(HtmlVorlagenPath + 'MonDa_Index.html');
    WriteGlobal('save&delete GERÄT');
    WriteGlobal('Titel=' + long2dateText(DateGet) + ' bis ' + long2dateText(DatePlus(DateGet, pred(JonDaVorlauf))));

    //
    EnsureHourGlass;

    ApiFirst;
    ProgressBar1.Max := RecordCount;
    LastGeraeteNo := '?';
    while not(eof) do
    begin

      MONTEUR_R := FieldByName('RID').AsInteger;

      //
      WriteLocal('load GERÄT');

      // Monteure
      EinMonteurL.clear;
      EinMonteurL.add(MONTEUR_R);
      Monteur := e_r_MonteurKuerzel(FieldByName('RID').AsInteger);

      // Datums
      DatumsL.clear;

      // für "ewige" Termine, die auf das MDE drauf sollen!
      DatumsL.add(cMonDa_ImmerAusfuehren);

      // für nicht fixierte Termine, die der Monteur selbst wählen kann!
      DatumsL.add(cMonDa_FreieTerminWahl);

      // Heutiger Tag bis zum pred("Heutiger Tag" + Vorlauf)
      for n := 0 to pred(JonDaVorlauf) do
        DatumsL.add(DatePlus(DateGet, n));

      // Geräte ID
      GeraeteNo := FieldByName('MONDA').AsString;

      // ev. noch weitere Tage hinzu?!
      for n := 0 to pred(Memo1.lines.count) do
        if pos(Monteur + ',', Memo1.lines[n]) = 1 then
        begin
          _Datum := date2long(nextp(Memo1.lines[n], ',', 1));
          if (DatumsL.indexof(_Datum) = -1) then
            DatumsL.add(_Datum);
        end;

      // Neue Auftragsdatei anfangen?!
      if (LastGeraeteNo <> GeraeteNo) then
      begin
        FileDelete(MdePath + GeraeteNo + '.DAT');
        FileAlive(MdePath + GeraeteNo + '.DAT');
        LastGeraeteNo := GeraeteNo;
      end;

      Label3.caption := Monteur + '-' + GeraeteNo + ' ...';
      application.ProcessMessages;

      // Ganz normale Terminliste erzeugen!
      FormAuftragArbeitsplatz.ProduceInfoBlatt(DatumsL, EinMonteurL, nil, true);

      // Geräte-Daten hochladen
      FTPup.add(MdePath + GeraeteNo + '.DAT' + ';' + ';' + GeraeteNo + '.DAT');

      // Abgezogene
      if CheckBox11.Checked then
      begin

        //
        sMONTEUR_R := inttostr(MONTEUR_R);
        lAbgezogen := e_r_sqlm(
          { } 'select distinct ' +
          { } ' H.MASTER_R ' +
          { } 'from ' +
          { } ' AUFTRAG H ' +
          { } 'join AUFTRAG A on ' +
          { } ' (A.STATUS<>6) and ' +
          { } ' (A.RID=H.MASTER_R) and ' +
          { } ' ( ' +
          { } '  (A.MONTEUR1_R is null) or ' +
          { } '  ((A.MONTEUR1_R<>' + sMONTEUR_R + ') and (A.MONTEUR2_R is null)) or ' +
          { } '  ((A.MONTEUR1_R<>' + sMONTEUR_R + ') and (A.MONTEUR2_R<>' + sMONTEUR_R + ')) ' +
          { } ' ) ' +
          { } 'where ' +
          { } ' (H.STATUS=6) and ' +
          { } ' (H.MONTEUREXPORT is not null) and ' +
          { } ' ((H.MONTEUR1_R=' + sMONTEUR_R + ') or (H.MONTEUR2_R=' +
          { } sMONTEUR_R + ')) ');

        lAbgezogen.SaveToFile(MdePath + 'abgezogen.' + GeraeteNo + '.dat');

        FTPup.add(MdePath + 'abgezogen.' + GeraeteNo + '.dat' + ';' + ';' + 'abgezogen.' + GeraeteNo + '.dat');

        lAbgezogen.free;
      end;

      // Monteure-Kurz-Info
      if CheckBox2.Checked then
        FTPup.add(MdePath + 'MonDa' + inttostr(EinMonteurL[0]) + '.html' + ';' + ';' + 'MonDa' + inttostr(EinMonteurL[0]
          ) + '.html');

      //
      WriteLocal('Monteur=' + FieldByName('NAME1').AsString);
      WriteLocal('Link=MonDa' + FieldByName('RID').AsString + '.html');
      WriteLocal('Gerät=' + GeraeteNo);
      WriteLocal('AnzTermine=' + inttostr(FormAuftragArbeitsplatz._LastTerminCount));
      WritePageBreak;

      //

      ShowStep; { 3. }

      ApiNext;

    end;

    WriteValue;
    SaveToFileCompressed(MdePath + 'Index.html');

    // FTP - Up
    if CheckBox2.Checked then
      FTPup.add(MdePath + 'Index.html' + ';' + ';' + 'index.html');

  end;

  // Wenn gewünscht FTP Upload!
  if CheckBox1.Checked then
    doFTPup;

  //
  BerichtL.addstrings(IndexH);
  BerichtL.SaveToFile(DiagnosePath + 'MobilVolumen_' + inttostrN(JONDA_TAN, 6) + '.log.txt');

  cPERSON.free;
  DatumsL.free;
  EinMonteurL.free;
  IndexH.free;
  BerichtL.free;
  lAbgearbeitet.free;
  lMonteure.free;
  FTPup.free;
  Memo1.lines.clear;

  ProgressBar1.Position := 0;

  Label3.caption := '';

  result := (ErrorCount = 0);
  if result and CloseLater then
    close;
  EndHourGlass;

end;

procedure TFormAuftragMobil.Button1Click(Sender: TObject);
begin
  if CheckBox4.Checked then
    ReadMobil;
  if CheckBox3.Checked then
    if not(WriteMobil) then
      ShowMessage('Es gab Fehler beim Hochladen, der Vorgang war nicht erfolgreich!' + #13 +
        'Mögliche Ursachen: * gestörter Zugang um InterNet' + #13 + '* Kein Recht für den Dienst passives FTP' + #13 +
        '* ftp-Server ist offline!' + #13 + '* Zugang zum ftp-Server verwehrt!' + #13 +
        '* Verbindung zum ftp-Server unterbrochen!')
    else
      openShell(MdePath + 'Index.html');
end;

procedure TFormAuftragMobil.FormActivate(Sender: TObject);
begin
  //
  if not(Initialized) then
  begin
    Initialized := true;
    ComboBox1.Items.addstrings(e_r_MonteureJonDa);
    RefreshGeraeteAuswahl;
  end;
end;

procedure TFormAuftragMobil.FormCreate(Sender: TObject);
begin
  IdFTP1 := TIdFTP.create(self);
end;

procedure TFormAuftragMobil.Button2Click(Sender: TObject);
begin
  if (pos('<', ComboBox1.Items[ComboBox1.itemindex]) = 0) then
    Memo1.lines.add(ComboBox1.Items[ComboBox1.itemindex]);
end;

procedure TFormAuftragMobil.Button3Click(Sender: TObject);
begin
  Memo1.lines.clear;
end;

function TFormAuftragMobil.ReadMobil: boolean;

var
  AuftragArray: array of TMDErec;
  ERGEBNIS_TAN: integer;
  MdeRecordCount: integer;
  INf: file of TMDErec; // Ergebnisdaten als mderec
  sTAN: TSearchStringList; // Ergebnisdaten als csv-Datei
  DirList: TStringList;
  Bericht: TStringList;
  Aenderungen: TStringList;
  AUSFUEHREN: TAnfixDate;

  Stat_Meldungen: integer;
  Stat_Aenderungen: integer;
  Stat_FehlendeRIDS: integer;

  ErrorCount: integer;
  StartTime: dword;
  Ergaenzungsmodus: boolean;

  function toDataBaseString(s: string; len: integer): string;
  begin
    result := s;
    ersetze('''', '', result);
    ersetze('"', '', result);
    result := '''' + copy(result, 1, len) + '''';
  end;

  function VNfromTime(t: TAnfixTime): string;
  begin
    if (t <= cNoon) then
      result := cVormittagsChar
    else
      result := cNachmittagsChar;
  end;

  function NeuerAuftrag(var mderec: TMDErec): integer;
  var
    qAUFTRAG: TIB_Query;
    BAUSTELLE_R: integer;
    MONTEUR_R: integer;
    Protokoll: TStringList;
    OneLine: string;
  begin
    result := -1;
    Protokoll := TStringList.create;
    with mderec do
    begin

      repeat

        // Protokoll mal einlesen
        Protokoll.clear;
        OneLine := Oem2ansi(ProtokollInfo);
        while (OneLine <> '') do
          Protokoll.add(nextp(OneLine, ';'));

        // Überhaupt Daten vorhanden?
        if (Protokoll.Values['BG'] = '') and (ausfuehren_ist_Datum <= 0) then
          break;

        // Vorbelegung der Werte
        if (RID > 0) then
        begin
          BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(RID));
          MONTEUR_R := e_r_sql('select MONTEUR1_R from AUFTRAG where RID=' + inttostr(RID));
        end
        else
        begin
          BAUSTELLE_R := 279; // grrrrrrrrrrrrr - argh -
          MONTEUR_R := e_r_sql('select RID from PERSON where MONDA=''' + Baustelle + '''');
        end;

        // ohne Monteur / Baustelle geht nix!
        if (MONTEUR_R <= 0) or (BAUSTELLE_R <= 0) then
          break;

        if (ausfuehren_ist_Datum <= 0) then
        begin
          ausfuehren_ist_Datum := date2long(nextp(Monteur_Info, ' - ', 0));
          ausfuehren_ist_uhr := StrToSeconds(nextp(Monteur_Info, ' - ', 1));
        end;

        if (ausfuehren_ist_Datum <= cMonDa_ImmerAusfuehren) then
        begin
          ausfuehren_ist_Datum := DateGet;
          ausfuehren_ist_uhr := SecondsGet;
        end;

        // eindeutiges Handle erzeugen
        RID := e_w_gen('GEN_AUFTRAG');

        // den Auftrag einfach mal anlegen
        e_x_sql('insert into auftrag (ZAEHLER_NUMMER,KUNDE_STRASSE,KUNDE_ORT,AUSFUEHREN,VORMITTAGS,MONTEUR1_R,BAUSTELLE_R,RID_AT_IMPORT)  values ('
          +

          // aufgenommene Regler Nummer
          toDataBaseString(cutblank(Protokoll.Values['BG']), 15) + ',' +

          // aufgenommene Strasse
          toDataBaseString(cutblank(cutblank(Protokoll.Values['I5']) + ' ' + cutblank(Protokoll.Values['I6']) + ' ' +
          cutblank(Protokoll.Values['I7']) + ' '), 45) + ',' +

          // aufgenommener Ort
          toDataBaseString(cutblank(cutblank(Protokoll.Values['I3']) + ' ' + cutblank(Protokoll.Values['I4'])),
          45) + ',' +

          // Ausführungsdatum
          toDataBaseString(long2date(ausfuehren_ist_Datum), 10) + ',' +

          // Ausführungsuhrzeit
          toDataBaseString(VNfromTime(ausfuehren_ist_uhr), 1) + ',' +

          inttostr(MONTEUR_R) + ',' + inttostr(BAUSTELLE_R) + ',' + inttostr(RID) + ')');

        // den Auftrag durch den Kernel absegnen lassen
        qAUFTRAG := DataModuleDatenbank.nQuery;
        with qAUFTRAG do
        begin
          sql.add('select * from auftrag where');
          sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
          sql.add(' (MONTEUR1_R=' + inttostr(MONTEUR_R) + ') and');
          sql.add(' (RID_AT_IMPORT=' + inttostr(RID) + ')');
          sql.add('for update');
          open;
          first;
          if not(eof) then
          begin
            result := FieldByName('RID').AsInteger;
            edit;
            AuftragBeforePost(qAUFTRAG);
            post;
          end;
        end;
        qAUFTRAG.free;

      until true;
    end;
    Protokoll.free;
  end;

  procedure ProcessNewData(pPath: string; pTAN: string);
  var
    qAUFTRAG: TIB_Query;

    // gecachte Datenbankfelder
    INTERN_INFO: TStringList;
    Protokoll: TStringList;
    V, V_Neu: TStringList;
    V_OldCount: integer;
    STATUS: integer;
    VMITTAGS: string;

    Stat_Wert_Ueberschreibungen: integer;
    Stat_Wert_Beitrag: integer;
    Stat_Changes: string;

    procedure updateField(sFieldName: string; NewValue: string);
    var
      OldValue: string;
    begin
      OldValue := qAUFTRAG.FieldByName(sFieldName).AsString;
      repeat

        // keine Wertänderung
        if (OldValue = NewValue) then
        begin
          // keine weitere Aktion notwendig!!
          break;
        end;

        // etwas soll durch nichts ersetzt werden -> nicht möglich
        if (NewValue = '') and (OldValue <> '') then
        begin
          // Eine Löschung der Eintragung wird nicht zugelassen (Einbahnstrasse)
          break;
        end;

        // der Normal-Fall: bisher keine Eintrag, nun jedoch füllen
        if (OldValue = '') and (NewValue <> '') then
        begin
          // Ersteintrag!!
          qAUFTRAG.FieldByName(sFieldName).AsString := NewValue;
          inc(Stat_Wert_Beitrag);
          Stat_Changes := Stat_Changes + sFieldName + '=' + NewValue + cProtokollTrenner;
          break;
        end;

        // eine Abänderung eines bestehenden Wertes!
        if not(Ergaenzungsmodus) then
          if (OldValue <> NewValue) then
          begin
            // Änderung!!
            qAUFTRAG.FieldByName(sFieldName).AsString := NewValue;
            inc(Stat_Wert_Ueberschreibungen);
            inc(Stat_Wert_Beitrag);
            Stat_Changes := Stat_Changes + sFieldName + '*' + NewValue + cProtokollTrenner;
            break;
          end;

      until true;

    end;

    procedure neuerSTATUS(NewStatus: integer);
    begin
      repeat

        // keine Wertänderung
        if (STATUS = NewStatus) then
        begin
          // keine weitere Aktion notwendig!!
          break;
        end;

        // eine Abänderung eines bestehenden Wertes!
        if not(Ergaenzungsmodus) then
          if (STATUS <> NewStatus) then
          begin
            // Änderung!!
            qAUFTRAG.FieldByName('STATUS').AsInteger := NewStatus;
            inc(Stat_Wert_Ueberschreibungen);
            inc(Stat_Wert_Beitrag);
            Stat_Changes := Stat_Changes + 'STATUS' + '*' + inttostr(NewStatus) + cProtokollTrenner;
            break;
          end;

      until true;
    end;

    procedure V_add(s: string);
    begin
      repeat
        if (s = '') then
          break;
        if (V.indexof(s) <> -1) then
          break;
        V.add(s);
      until true;
    end;

  var
    n, m, k: integer;
    OneLine: string;
    ProtParameterName: string;
    ProtValue: string;
    OldValue: string;
    _RID: integer;

  begin

    // Anzeigen, um was es geht!
    Label3.caption := inttostrN(ERGEBNIS_TAN, 6) + '.' + pTAN;
    application.ProcessMessages;

    INTERN_INFO := TStringList.create;
    Protokoll := TStringList.create;
    V := TStringList.create;
    V_Neu := TStringList.create;
    sTAN := TSearchStringList.create;

    // Einlesen der TAN Daten als Text
    if FileExists(pPath + pTAN + cUTF8DataExtension) then
      sTAN.LoadFromFile(pPath + pTAN + cUTF8DataExtension);

    // Einlesen der TAN Datei (alte Art!)
    AssignFile(INf, pPath + pTAN + cDATExtension);
    reset(INf);
    MdeRecordCount := FileSize(INf);
    inc(Stat_Meldungen, MdeRecordCount);

    //
    Bericht.add('[I] Verarbeite Monteur TAN ' + pTAN + ' mit ' + inttostr(MdeRecordCount) + ' Datensätzen');

    SetLength(AuftragArray, MdeRecordCount);
    for n := 0 to pred(MdeRecordCount) do
      read(INf, AuftragArray[n]);
    CloseFile(INf);

    // Übertragen in die Datenbank
    // Verfahren dabei:
    // MONDA_SCHUTZ verhindert jegliche Manipulation durch Monda
    //
    // Problem 1:
    // Tag1 : Monteur setzt auf Neu Anschreiben
    // Tag2 : Büro vereinbart neuen Termin
    // Tag3 : es wird nochmals "Neu Anschreiben" gemeldet
    //
    // wichtig: hat das Büro dann schon umterminiert darf am Termin
    // nichts mehr gemacht werden.
    // -> Sonderbehandlung der Stati "Restat" und "Neu Anschreiben"
    //
    // Problem 2:
    // Tag1: Monteur liefert V1=xxx, V2=yyy
    // Tag2: Der Termin wird vom Büro NEU eingeplant
    // Tag3: Monteur liefert V1=zzz
    // -> V1 darf hier nicht überschrieben werden es muss angereiht werden (Implementiert!)
    //
    qAUFTRAG := DataModuleDatenbank.nQuery;
    with qAUFTRAG do
    begin
      sql.add('SELECT * FROM');
      sql.add(' AUFTRAG');
      sql.add('WHERE');

      // der Meister!
      sql.add(' (RID=(select MASTER_R from AUFTRAG where RID=:CROSSREF)) and');

      // ungesetzer Monda Schutz
      sql.add(' ((MONDA_SCHUTZ IS NULL) OR (MONDA_SCHUTZ=''' + cC_False + ''')) and');

      // nicht ein ewiger Termin (die haben auch einen Schutz!)
      sql.add(' ((AUSFUEHREN IS NULL) OR (AUSFUEHREN <> ''01.01.2000''))');

      sql.add('for update');

      for n := 0 to pred(MdeRecordCount) do
      begin
        with AuftragArray[n] do
        begin
          if (ausfuehren_ist_Datum <> cMonDa_Status_Wegfall) and (ausfuehren_ist_Datum <> cMonDa_Status_Info) and
            (ausfuehren_ist_Datum <> cMonDa_Status_unbearbeitet) then
          begin

            // Orginal-Daten retten
            _RID := RID;

            // Daten vorbereiten
            zaehlernummer_neu := TJonDaExec.formatZaehlerNummerNeu(zaehlernummer_neu);

            // Neuen Auftrag anlegen?
            if (RID = -1) or (ausfuehren_soll = cMonDa_ImmerAusfuehren) then
              RID := NeuerAuftrag(AuftragArray[n]);

            ParamByName('CROSSREF').AsInteger := RID;
            if not(Active) then
              open;
            first;

            if IsEmpty then
              if (iTagwacheBaustelle >= cRID_FirstValid) then
              begin

                //
                RID :=
                { } e_r_sql(
                  { } 'select MASTER_R from AUFTRAG where ' +
                  { } '(ZAEHLER_NUMMER=''' + zaehlernummer_alt + ''') and' +
                  { } '(BAUSTELLE_R=' + inttostr(iTagwacheBaustelle) + ')');

                if (RID >= cRID_FirstValid) then
                  ParamByName('CROSSREF').AsInteger := RID;
              end;

            if not(IsEmpty) then
            begin

              // Init
              Stat_Wert_Ueberschreibungen := 0;
              Stat_Wert_Beitrag := 0;
              Stat_Changes := '';

              // bisherige Werte auslesen
              AUSFUEHREN := DateTime2long(FieldByName('AUSFUEHREN').AsDate);
              VMITTAGS := FieldByName('VORMITTAGS').AsString;
              STATUS := FieldByName('STATUS').AsInteger;
              Ergaenzungsmodus := FieldByName('EXPORT_TAN').IsNotNull;
              FieldByName('INTERN_INFO').AssignTo(INTERN_INFO);
              FieldByName('PROTOKOLL').AssignTo(Protokoll);

              // Vergebliche Besuche
              V_Neu.clear;
              V.clear;
              for m := 1 to 10 do
                V_add(Protokoll.Values['V' + inttostr(m)]);
              V_OldCount := V.count;

              // gehe in den Edit-Modus
              edit;

              // wird immer Eingetragen: der Ergebnis-Kontakt
              INTERN_INFO.add('ERGEBNIS.' + inttostrN(ERGEBNIS_TAN, 6) + '=' + pTAN);

              // Protokoll-String aufbereiten
              k := sTAN.FindInc(inttostr(RID));
              if (k <> -1) then
              begin
                OneLine := nextp(sTAN[k], ';', cMobileMeldung_COLUMN_PROTOKOLL);
                ersetze(cJondaProtokollDelimiter, ';', OneLine);
              end
              else
              begin
                OneLine := Oem2ansi(ProtokollInfo);
              end;

              // Parameter für Parameter!
              while (OneLine <> '') do
              begin

                ProtValue := nextp(OneLine, ';');
                ProtParameterName := nextp(ProtValue, '=');
                OldValue := Protokoll.Values[ProtParameterName];

                if (ProtParameterName <> '') then
                begin
                  repeat

                    // Spezialbehandlung für V1,V2,V3
                    if (pos('V', ProtParameterName) = 1) then
                    begin
                      V_Neu.add(ProtParameterName + '=' + ProtValue);
                      break;
                    end;

                    // keine Wertänderung
                    if (OldValue = ProtValue) then
                    begin
                      // keine weitere Aktion notwendig!!
                      break;
                    end;

                    // etwas soll durch nichts ersetzt werden -> nicht möglich
                    if (ProtValue = '') and (OldValue <> '') then
                    begin
                      // Eine Löschung der Eintragung wird nicht zugelassen (Einbahnstrasse)
                      break;
                    end;

                    // der Normal-Fall: bisher keine Eintrag, nun jedoch füllen
                    if (OldValue = '') and (ProtValue <> '') then
                    begin
                      // Ersteintrag!!
                      Protokoll.Values[ProtParameterName] := ProtValue;
                      inc(Stat_Wert_Beitrag);
                      Stat_Changes := Stat_Changes + ProtParameterName + '=' + ProtValue + cProtokollTrenner;
                      break;
                    end;

                    // eine Abänderung eines bestehenden Wertes!
                    if not(Ergaenzungsmodus) then
                      if (OldValue <> ProtValue) then
                      begin
                        // Änderung!!
                        Protokoll.Values[ProtParameterName] := ProtValue;
                        inc(Stat_Wert_Ueberschreibungen);
                        inc(Stat_Wert_Beitrag);
                        Stat_Changes := Stat_Changes + ProtParameterName + '*' + ProtValue + cProtokollTrenner;
                        break;
                      end;

                  until true;
                end;
              end;

              // Alle neuen V nun Hinzunehmen
              V_Neu.sort; // V1, V2 Reihenfolge sicherstellen!
              for m := 0 to pred(V_Neu.count) do
                V_add(nextp(V_Neu[m], '=', 1));

              // imp pend: Alle Vs, nun in Hinsicht auf den Zeitstempel-Wert sortieren!

              // Alle Vs nun dauerhaft Speichern
              for m := 0 to 9 do
              begin

                // Name=Value ermitteln
                ProtParameterName := 'V' + inttostr(succ(m));
                OldValue := Protokoll.Values[ProtParameterName];
                if (m < V.count) then
                  ProtValue := V[m]
                else
                  ProtValue := '';

                // speichern bzw. leeren
                if (OldValue <> ProtValue) then
                begin
                  Protokoll.Values[ProtParameterName] := ProtValue;
                  inc(Stat_Wert_Beitrag);
                  Stat_Changes := Stat_Changes + ProtParameterName + '=' + ProtValue + cProtokollTrenner;
                end;

              end;

              // Status Berechnungen
              case ausfuehren_ist_Datum of

                cMonDa_Status_FallBack, cMonDa_Status_Restant:
                  begin

                    // Meint der Monteur auch diese Variante?
                    if (ausfuehren_soll = AUSFUEHREN) and (VormittagsToChar(vormittags) = VMITTAGS) and

                    // Neu-Anschreiben schützt vor Status Restant
                      (STATUS <> cs_NeuAnschreiben) and (STATUS <> cs_Erfolg) and (STATUS <> cs_Vorgezogen) and
                      (STATUS <> cs_Unmoeglich) and

                    // Termin liegt in der Vergangenheit
                      (AUSFUEHREN < DateGet) then
                      neuerSTATUS(cs_Restant);

                  end;

                cMonDa_Status_NeuAnschreiben:
                  begin

                    // Meint der Monteur auch diese Variante?
                    if (ausfuehren_soll = AUSFUEHREN) and (VormittagsToChar(vormittags) = VMITTAGS) and
                      (STATUS <> cs_Erfolg) and (STATUS <> cs_Vorgezogen) and (STATUS <> cs_Unmoeglich)

                    then
                      neuerSTATUS(cs_NeuAnschreiben);
                  end;

                cMonDa_Status_Unmoeglich:
                  begin
                    neuerSTATUS(cs_Unmoeglich);
                  end;
                cMonDa_Status_Vorgezogen:
                  begin

                    if (STATUS <> cs_Erfolg) then
                      neuerSTATUS(cs_Vorgezogen);

                  end;

              else

                // Erfolgs-Status!
                neuerSTATUS(cs_Erfolg);

                if DateOK(ausfuehren_ist_Datum) then
                begin
                  if (ausfuehren_ist_Datum < 20040000) then
                  begin
                    ausfuehren_ist_Datum := ausfuehren_soll;
                    ausfuehren_ist_uhr := 0;
                  end;
                  if not(Ergaenzungsmodus) then
                    FieldByName('ZAEHLER_WECHSEL').AsDateTime := mkDateTime(ausfuehren_ist_Datum, ausfuehren_ist_uhr);
                end;

              end;

              // In allen Fälle: diese Fehler gehören MonDa
              updateField('REGLER_NR_KORREKTUR', reglernummer_korr);
              updateField('REGLER_NR_NEU', reglernummer_neu);
              updateField('ZAEHLER_NR_KORREKTUR', zaehlernummer_korr);
              updateField('ZAEHLER_NR_NEU', zaehlernummer_neu);
              updateField('ZAEHLER_STAND_ALT', zaehlerstand_alt);
              updateField('ZAEHLER_STAND_NEU', zaehlerstand_neu);

              // Weitere Zuweisungen
              FieldByName('PROTOKOLL').Assign(Protokoll);
              FieldByName('INTERN_INFO').Assign(INTERN_INFO);

              // Speichern
              if (Stat_Wert_Beitrag > 0) then
              begin
                Aenderungen.add(inttostr(RID) + ';' + Stat_Changes);
                ForceHistorischer := (Stat_Wert_Ueberschreibungen > 0);
                AuftragBeforePost(qAUFTRAG);
                inc(Stat_Aenderungen);
              end;
              post;

            end
            else
            begin
              // Log, dass dieser RID nicht gefunden wurde!
              inc(Stat_FehlendeRIDS);
              Bericht.add('[E] (RID=' + inttostr(_RID) + ') (Z#=' + zaehlernummer_alt + ') Datensatz nicht gefunden!');
            end;

          end;
        end;
        if frequently(StartTime, 222) then
          application.ProcessMessages;
      end;
      close;
    end;
    qAUFTRAG.close;
    INTERN_INFO.free;
    Protokoll.free;
    V.free;
    V_Neu.free;
    sTAN.free;
  end;

var
  n: integer;
  CloseLater: boolean;
  _sBearbeiter: integer; // typeof(sBearbeiter)
  TAN: string;
begin
  result := true;
  ERGEBNIS_TAN := 0;

  if FileExists(HtmlVorlagenPath + 'MonDa_Index.html') then
  begin

    //
    BeginHourGlass;
    Label3.caption := 'Vorlauf ...';
    application.ProcessMessages;

    CloseLater := false;
    if not(Active) then
    begin
      CloseLater := true;
      show;
    end;

    CheckCreateDir(AuftragMobilServerPath);
    CheckCreateDir(MdePath);
    ErrorCount := 0;
    DirList := TStringList.create;
    Bericht := TStringList.create;
    Aenderungen := TStringList.create;
    Aenderungen.add('RID;INFO');

    Bericht.add(datum + ' ' + uhr);
    Stat_Meldungen := 0;
    Stat_Aenderungen := 0;
    Stat_FehlendeRIDS := 0;
    StartTime := 0;

    SolidFTP_Retries := 200;
    SolidInit(IdFTP1);
    with IdFTP1 do
    begin
      Host := nextp(iMobilFTP, ';', 0);
      UserName := nextp(iMobilFTP, ';', 1);
      Password := nextp(iMobilFTP, ';', 2);
    end;

    // neue TANs downloaden
    if CheckBox5.Checked then
    begin
      Label3.caption := 'FTP ...';
      application.ProcessMessages;

      solidGet(
        { } IdFTP1,
        { } '',
        { } cJonDa_ErgebnisMaske_deprecated_FTP,
        { } cJonDa_ErgebnisMaske_deprecated,
        { } AuftragMobilServerPath,
        { } not(CheckBox6.Checked));

      solidGet(
        { } IdFTP1,
        { } '',
        { } cJonDa_ErgebnisMaske_utf8_FTP,
        { } cJonDa_ErgebnisMaske_utf8,
        { } AuftragMobilServerPath,
        { } not(CheckBox6.Checked));
      try
        IdFTP1.Disconnect;
      except
      end;
    end;

    // TANs auflisten und verarbeiten
    dir(AuftragMobilServerPath + cJonDa_ErgebnisMaske_deprecated, DirList);
    DirList.sort;

    // jede einzelne TAN abarbeiten
    ProgressBar1.Max := DirList.count;

    // Reihenfolge: Ältestes zuerst verarbeiten!
    if (DirList.count > 0) then
    begin

      _sBearbeiter := sBearbeiter;
      if (iJonDaAdmin >= cRID_FirstValid) then
        sBearbeiter := iJonDaAdmin;

      ERGEBNIS_TAN := e_w_gen('GEN_ERGEBNIS');
      for n := 0 to pred(DirList.count) do
      begin

        try

          // Verarbeiten!
          TAN := ExtractFileNameWithoutExtension(DirList[n]);
          ProcessNewData(AuftragMobilServerPath, TAN);

          // Lokal löschen!
          if CheckBox10.Checked then
            FileMove(AuftragMobilServerPath + TAN + '.*', DiagnosePath);

        except
          on e: exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' ReadMobil: ' + 'TAN: ' + TAN + ': ' + e.message);
            Bericht.add('[E] ' + DirList[n]);
          end;
        end;

        ProgressBar1.Position := n;
        application.ProcessMessages;
      end;
      sBearbeiter := _sBearbeiter;
    end;

    //
    Bericht.add('[I] Meldungen: ' + inttostr(Stat_Meldungen));
    Bericht.add('[I] Änderungen: ' + inttostr(Stat_Aenderungen));
    if (Stat_FehlendeRIDS > 0) then
      Bericht.add('[I] WARNUNG: fehlende RIDS: ' + inttostr(Stat_FehlendeRIDS));

    Bericht.add('-----------');
    Bericht.SaveToFile(DiagnosePath + 'MobilAuslesen_' + inttostrN(ERGEBNIS_TAN, 6) + '.log.txt');
    Aenderungen.SaveToFile(DiagnosePath + 'MobilAuslesen_' + inttostrN(ERGEBNIS_TAN, 6) + '.csv');

    if assigned(SolidFTP_sLog) then
      if (SolidFTP_sLog.count > 0) then
        SolidFTP_sLog.SaveToFile(DiagnosePath + 'FTP_down_' + inttostrN(ERGEBNIS_TAN, 6) + '.log.txt');

    DirList.free;
    Bericht.free;
    Aenderungen.free;

    ProgressBar1.Position := 0;
    Label3.caption := '';

    // Im Verzeichnis aufräumen!
    FileDelete(AuftragMobilServerPath + '*.DAT', 10);

    result := (ErrorCount = 0);
    if result and CloseLater then
      close;
    EndHourGlass;
  end;
end;

procedure TFormAuftragMobil.Button4Click(Sender: TObject);
var
  INf: file of TMDErec;
  OneRec: TMDErec;
  DebugF: TStringList;
  InfoF: TStringList;
  Auftrag: TIB_Cursor;
  _Status: integer;
  _MondaSchutz: boolean;
  _result: string;
  n, RecCount: integer;
begin
  BeginHourGlass;
  Auftrag := DataModuleDatenbank.nCursor;
  Auftrag.sql.add('SELECT * FROM AUFTRAG WHERE RID=:CROSSREF');
  Auftrag.open;

  DebugF := TStringList.create;
  InfoF := TStringList.create;
  AssignFile(INf, AuftragMobilServerPath + 'AUFTRAG.' + ComboBox2.Text + '.DAT');
  reset(INf);
  RecCount := FileSize(INf);
  n := 0;
  while not(eof(INf)) do
  begin
    read(INf, OneRec);
    inc(n);
    if (OneRec.ausfuehren_ist_Datum = cMonDa_Status_Restant) then
    begin
      with Auftrag do
      begin
        ParamByName('CROSSREF').AsInteger := OneRec.RID;
        ApiFirst;
        if not(eof) then
        begin

          _Status := FieldByName('STATUS').AsInteger;
          _MondaSchutz := (FieldByName('MONDA_SCHUTZ').AsString = 'Y');

          if (_Status = ord(ctsRestant)) then
          begin
            _result := 'OK (echter Restat)';
          end
          else
          begin
            _result := ' eigentlich ' + cPhasenStatusText[_Status] + ' ' + FieldByName('AUSFUEHREN').AsString + ' ' +
              FieldByName('ZAEHLER_WECHSEL').AsString;
          end;
          if _MondaSchutz then
            _result := _result + ' Keine weiteren Eingaben möglich!';

        end
        else
        begin
          _result := 'bitte als "unmögl" markieren!';
        end;

        DebugF.add(inttostr(n) + '/' + inttostr(RecCount) + ' ' + OneRec.Monteur + ' ' + OneRec.Art + '-' +
          OneRec.zaehlernummer_alt + ': ->' + _result);

      end;
    end;
  end;
  Auftrag.close;
  Auftrag.free;
  CloseFile(INf);
  DebugF.SaveToFile(DiagnosePath + 'Restaten.txt');
  DebugF.free;
  InfoF.free;
  EndHourGlass;
  openShell(DiagnosePath + 'Restaten.txt');
end;

procedure TFormAuftragMobil.Button5Click(Sender: TObject);
var
  INf: file of TMDErec;
  OneRec: TMDErec;
  DebugF: TStringList;
  InfoF: TStringList;
  deletecount: integer;
begin
  //
  BeginHourGlass;
  DebugF := TStringList.create;
  InfoF := TStringList.create;
  AssignFile(INf, AuftragMobilServerPath + 'AUFTRAG.' + ComboBox2.Text + '.DAT');
  reset(INf);
  while not(eof(INf)) do
  begin
    read(INf, OneRec);
    DebugF.add(inttostr(OneRec.RID));
  end;
  CloseFile(INf);
  DebugF.sort;
  removeduplicates(DebugF, deletecount, InfoF);
  InfoF.SaveToFile(DiagnosePath + 'Doppelte.txt');
  DebugF.free;
  InfoF.free;
  EndHourGlass;

  //
  openShell(DiagnosePath + 'Doppelte.txt');
end;

procedure TFormAuftragMobil.RefreshGeraeteAuswahl;
var
  n: integer;
  AllGeraete: TStringList;
begin
  AllGeraete := TStringList.create;
  dir(AuftragMobilServerPath + 'AUFTRAG.???.DAT', AllGeraete, false);
  AllGeraete.sort;
  ComboBox2.Items.clear;
  for n := 0 to pred(AllGeraete.count) do
    ComboBox2.Items.add(nextp(AllGeraete[n], '.', 1));
  AllGeraete.free;
end;

procedure TFormAuftragMobil.SpeedButton2Click(Sender: TObject);
begin
  openShell(DiagnosePath);
end;

procedure TFormAuftragMobil.Log(s: string);
begin
  if pos(cERRORText, s) > 0 then
    CareTakerLog(s);
end;

procedure TFormAuftragMobil.Button6Click(Sender: TObject);
begin
  openShell(MdePath + 'Index.html');
end;

procedure TFormAuftragMobil.Button7Click(Sender: TObject);
begin
  openShell('http://orgamon.de/JonDaServer/Statistik/');
end;

end.
