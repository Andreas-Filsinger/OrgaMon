unit SystemSettings;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Grids, ExtCtrls, DBGrids,
  ComCtrls,
  anfix32;

type
  TFormSystemSettings = class(TForm)
    Button16: TButton;
    Timer1: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    open: TButton;
    Button18: TButton;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label7: TLabel;
    Button14: TButton;
    Button15: TButton;
    Label4: TLabel;
    Button4: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button13: TButton;
    Label14: TLabel;
    Button17: TButton;
    ProgressBar2: TProgressBar;
    TabSheet5: TTabSheet;
    Label5: TLabel;
    Button3: TButton;
    Button5: TButton;
    Button7: TButton;
    Button12: TButton;
    Button2: TButton;
    Button6: TButton;
    Button8: TButton;
    Label8: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    Button19: TButton;
    CheckBox1: TCheckBox;
    Button20: TButton;
    ProgressBar3: TProgressBar;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Label10: TLabel;
    Button24: TButton;
    Label11: TLabel;
    Button25: TButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button26: TButton;
    CheckBox4: TCheckBox;
    Button27: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    TagesAbschluss: boolean;

    function IsKFZKennzeichen(s: string): boolean;
    procedure BesucherIndexErzeugen;

  end;

var
  FormSystemSettings: TFormSystemSettings;

implementation

uses
  splash, globals, BesucherListe,
  WordIndex, Willkommen, Import,
  wanfix32, InfoZip;

{$R *.DFM}

procedure TFormSystemSettings.FormCreate(Sender: TObject);
begin
  SplashWrite('Rev. ' + RevToStr(globals.Version));
end;

procedure TFormSystemSettings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    Key := #0;
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormSystemSettings.Button4Click(Sender: TObject);
var
  BoehmListe: TStringList;
  BoehmResult: TStringList;
  OneLine: string;
  n: integer;
  _Name: string;
begin
  //
  BoehmResult := TStringList.Create;
  BoehmListe := TStringList.Create;
  BoehmListe.LoadfromFile(MyProgramPath + 'Böhm.csv');

  for n := 0 to pred(BoehmListe.count) do
  begin
    OneLine := BoehmListe[n];
    NextP(OneLine, ';');
    _Name := NextP(OneLine, ';');
    if _Name = '' then
      continue;
    if pos('Datum', _Name) = 1 then
      continue;
    if ('Name' = _Name) then
      continue;
    BoehmResult.add(_Name + ';Böhm;;;Reinigungspersonal');
  end;

  BoehmListe.free;
  BoehmResult.SaveToFile(MyProgramPath + 'Böhm Ausgabe.txt');
  BoehmResult.free;
end;

// FahrzeugListe := TStringList.Create;

procedure TFormSystemSettings.Button9Click(Sender: TObject);
var
  FahrZeugListe: TStringList;
  FahrZeugeResult: TStringList;
  OneLine: string;
  n: integer;
  _Kennzeichen: string;
  _Firma: string;
  _Bemerkung: string;
  _Ort: string;
begin
  FahrZeugListe := TStringList.Create;
  FahrZeugeResult := TStringList.Create;
  FahrZeugListe.LoadfromFile(MyProgramPath + 'FRMDFARZ.csv');

  for n := 0 to pred(FahrZeugListe.count) do
  begin
    OneLine := FahrZeugListe[n];
    NextP(OneLine, ';');
    _Kennzeichen := NextP(OneLine, ';');
    if _Kennzeichen = '' then
      continue;
    if pos('Kennzeichen', _Kennzeichen) = 1 then
      continue;

    _Bemerkung := NextP(OneLine, ';');
    _Firma := NextP(OneLine, ';');
    NextP(OneLine, ';');
    NextP(OneLine, ';');
    NextP(OneLine, ';');
    _Ort := NextP(OneLine, ';');
    if _Ort <> '' then
      _Firma := _Firma + ' (' + _Ort + ')';

    FahrZeugeResult.add(';' + _Firma + ';' + _Kennzeichen + ';;' + _Bemerkung);

  end;

  FahrZeugeResult.SaveToFile(MyProgramPath + 'Fremdfahrzeuge Ausgabe.txt');
  FahrZeugListe.free;
  FahrZeugeResult.free;
end;

procedure TFormSystemSettings.Button10Click(Sender: TObject);
var
  AllData: TStringList;
begin
  AllData := TStringList.Create;
  LoadFromFileHugeLines(false, AllData,
    MyProgramPath + 'Fremdfahrzeuge Ausgabe.txt');
  LoadFromFileHugeLines(false, AllData, MyProgramPath + 'Böhm Ausgabe.txt');
  AllData.sorted := true;
  RemoveDuplicates(AllData);
  AllData.SaveToFile(MyProgramPath + 'Besucher Ausgabe.txt');
  AllData.free;
end;

procedure TFormSystemSettings.Button11Click(Sender: TObject);
var
  AllData: TStringList;
begin
  AllData := TStringList.Create;
  LoadFromFileHugeLines(false, AllData, MyProgramPath + 'Besucher Ausgabe.txt');
  LoadFromFileHugeLines(false, AllData, MyProgramPath + 'Besucher Stamm.txt');
  AllData.sorted := true;
  RemoveDuplicates(AllData);
  AllData.SaveToFile(MyProgramPath + cBesucherFName);
  AllData.free;
end;

procedure TFormSystemSettings.Button3Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besucher Hinweise DE.txt');
end;

procedure TFormSystemSettings.Button5Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besucher Hinweise US.txt');
end;

procedure TFormSystemSettings.Button7Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besuchsgründe.ini');
end;

procedure TFormSystemSettings.Button12Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Mitgebrachtes.ini');
end;

procedure TFormSystemSettings.Button13Click(Sender: TObject);
begin
  openShell(MyProgramPath + cIniFName);
end;

procedure TFormSystemSettings.FormActivate(Sender: TObject);
begin
  Label6.caption := inttostr(GetHeapStatus.TotalAllocated) +
    ' Bytes durch Anwendung benutzt!';
  if (iTagesAbschluss = 0) then
  begin
    Label14.caption := 'nicht automatisch!';
  end
  else
  begin
    Label14.caption := 'automatisch um ' +
      secondstostr5(iTagesAbschluss) + ' h';
  end;
  Label1.caption := 'CPU Leistung ca. ' + inttostr(CPUMhz) + ' MHz';
  Label2.caption := application.exename + ' Rev. ' + RevToStr(globals.Version);
  CheckBox2.checked := iPLEAImport;
  CheckBox3.checked := iADCMImport;
  CheckBox4.checked := iSCHEMAImport;
end;

procedure TFormSystemSettings.Button14Click(Sender: TObject);
var
  ListAll: TStringList;
  n, m: integer;
  OneLine: string;
  _Name: string;
  _Ort: string;
  _rest: string;

  UmsetzParameter: TStringList;
  UmsetzNew: TStringList;
  Umsetzer: string;
  UmsetzerSingle: string;
begin
  ListAll := TStringList.Create;
  if FileExists(MyProgramPath + 'Mitarbeiter aus Import.txt') then
    ListAll.LoadfromFile(MyProgramPath + 'Mitarbeiter aus Import.txt');
  if FileExists(MyProgramPath + 'Mitarbeiter zusätzlich.txt') then
    LoadFromFileHugeLines(false, ListAll,
      MyProgramPath + 'Mitarbeiter zusätzlich.txt');
  ListAll.sort;
  RemoveDuplicates(ListAll);
  if iMitarbeiterOrtUmsetzer <> '' then
  begin
    //
    Umsetzer := iMitarbeiterOrtUmsetzer;
    UmsetzParameter := TStringList.Create;
    UmsetzNew := TStringList.Create;
    while (Umsetzer <> '') do
    begin
      UmsetzerSingle := NextP(Umsetzer, ';');
      UmsetzParameter.add(cutblank(NextP(UmsetzerSingle, ',')));
      UmsetzNew.add(cutblank(UmsetzerSingle));
    end;

    for n := 0 to pred(ListAll.count) do
    begin
      OneLine := ListAll[n];
      _Name := NextP(OneLine, ';');
      _Ort := NextP(OneLine, ';');
      _rest := NextP(OneLine, ';');

      for m := 0 to pred(UmsetzParameter.count) do
        ersetze(UmsetzParameter[m], UmsetzNew[m], _Ort);
      ListAll[n] := _Name + ';' + cutblank(_Ort) + ';' + _rest;

    end;
    UmsetzParameter.free;
    UmsetzNew.free;
  end;
  ListAll.SaveToFile(MyProgramPath + cMitarbeiterFName);
  ListAll.free;
  Button16.SetFocus;
end;

procedure TFormSystemSettings.Button15Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Mitarbeiter zusätzlich.txt');
end;

procedure TFormSystemSettings.Button16Click(Sender: TObject);
begin
  ShowMessage('Bei Änderungen muss in der Regel die Anwendung'#13 +
    'neu gestartet werden, damit die Änderungen'#13 + 'wirksam werden!');
  close;
end;

procedure TFormSystemSettings.Button17Click(Sender: TObject);
var
  OldBesucher: TBesucherList;
  NewBesucher: TBesucherItem;
  DelBesucher: TStringList;
  DelBesucherFiles: TStringList;
  HistorieNews: TStringList;
  n, m, f: integer;
  OneLine: TLineRec;
  ToDay: TAnfixDate;
  OutListe: TLineList;
  Wochenbesucher: TLineList;
  ListeChanged: boolean;
  BesucherTANFound: boolean;
  WochenbesucherFound: boolean;
  id: integer;
  ActFname: string;
  ZipFiles: TStringList;
  ZipFName: string;

  procedure CopyHistorieToBesucher(h: TLineRec; b: TBesucherItem);
  var
    _ziel: string;
  begin
    with b do
    begin
      name := h.BesucherName;
      firma := h.firma;
      kennzeichen := h.kennzeichen;
      Handy := h.Handy;
      // Bemerkung
      grund := h.grund;
      anrede := h.anrede;
      datum := h.sDatum;
      tan := h.BesucherID;
      _ziel := h.BevorzugtesZiel;
      if (_ziel <> '') then
        ziel := _ziel;
      nation := h.Land;
      symbol := h.symbol;
    end;
  end;

begin

  if iTransactionServer then
  begin
    screen.cursor := crHourGlass;
    iTransactionServer := false;

    // 0) Werkzeuge anlegen
    OutListe := TLineList.Create;
    OldBesucher := TBesucherList.Create;
    HistorieNews := TStringList.Create;
    OneLine := TLineRec.Create;
    PageControl1.ActivePage := TabSheet3;
    ToDay := DateGet;
    DelBesucher := TStringList.Create;
    DelBesucherFiles := TStringList.Create;
    Wochenbesucher := TLineList.Create;
    BesucherListeForm.DrawGrid1.row := 0;

    // Wochenbesucher laden!
    if FileExists(MyProgramPath + 'Wochenbesucher.ini') then
      Wochenbesucher.LoadfromFile(MyProgramPath + 'Wochenbesucher.ini');

    // 1) ZIP {imp pend}
    ProgressBar2.position := 0;
    ZipFiles := TStringList.Create;
    ZipFiles.add(MyProgramPath + '*.ini');
    ZipFiles.add(MyProgramPath + '*.txt');
    ZipFName := MyProgramPath + cDatenSicherungPath + 'Sicherung ' +
      inttostr(NewTrn) + '.zip';
    if CheckBox1.checked then
      zip(ZipFiles, ZipFName, '');
    ZipFiles.free;

    // 2) alte Daten löschen
    FileDelete(MyProgramPath + cDatenSicherungPath + '*.*',
      DatePlus(ToDay, -20));
    FileDelete(MyProgramPath + cDiagnosePath + '*.*', DatePlus(ToDay, -20));
    FileDelete(MyProgramPath + cAblagePath + '*.*', DatePlus(ToDay, -20));

    // 2) zu "alte" Datensätze aus der liste.ini rauslöschen
    ProgressBar2.position := 50;
    FileSetAttr(MyProgramPath + cListeFName, 0);
    ListeChanged := false;

    // zu alte Wochenbesucher entfernen!
    for n := pred(Wochenbesucher.count) downto 0 do
      if Wochenbesucher[n].RepetierendBis < ToDay then
        Wochenbesucher.delete(n);

    for n := pred(BesucherListeForm.items.count) downto 0 do
    // erst orange, dann usw.
    begin
      with BesucherListeForm.items[n] do
        if RepetierendBis <> 0 then
        begin
          // BucheWochenBesucher
          if (RepetierendBis < ToDay) then
          begin
            // genehmigung ausgelaufen -> raus aus den Wochenbesuchern
            for m := pred(Wochenbesucher.count) downto 0 do
              if (Wochenbesucher[m].BesucherID = BesucherID) then
                Wochenbesucher.delete(m);
          end
          else
          begin

            // Datensatz finden und auffrischen
            WochenbesucherFound := false;
            for m := 0 to pred(Wochenbesucher.count) do
              if (BesucherID = Wochenbesucher[m].BesucherID) then
              begin
                // gefunden -> neu anpassen!
                CopyTo(Wochenbesucher[m]);
                WochenbesucherFound := true;
              end;

            if not(WochenbesucherFound) then
            begin
              // nicht gefunden -> neuer Wochenbesucher!
              OneLine := TLineRec.Create;
              CopyTo(OneLine);
              Wochenbesucher.insert(0, OneLine);
            end;

          end;
          if (PforteEin = 0) and (PforteAus = 0) then
          begin
            // nur aus der Planungszone die "gelben" entfernen!
            BesucherListeForm.items.delete(n);
            ListeChanged := true;
          end;
        end;
    end;

    for n := pred(BesucherListeForm.PastBorder) downto 0 do // die grauen!
    begin
      // Auf alle Fälle als neuer Besucher rausschreiben!
      OneLine := TLineRec.Create;
      BesucherListeForm.items[n].CopyTo(OneLine);
      OutListe.insert(0, OneLine);

      with BesucherListeForm.items[n] do
      begin
        // prüfen, ob Status grau erreicht ist!
        if (DateDiff(eDatum, ToDay) > iBelasseStatusGrau) then
        begin
          HistorieNews.insert(0, BesucherListeForm.items[n].SaveToString);
          BesucherListeForm.items.delete(n);
          ListeChanged := true;
        end;
      end;
    end;

    // nun alle gelben wieder rein!
    if not(WeekDay(ToDay) in [6, 7]) then
      for n := 0 to pred(Wochenbesucher.count) do
      begin
        ListeChanged := true;
        OneLine := TLineRec.Create;
        Wochenbesucher.items[n].CopyTo(OneLine);
        with OneLine do
        begin
          // Modifikationen für den Status "gelb"
          TrnID := NewTrn;
          PforteEin := 0;
          PfoertnerEin := '';
          PforteAus := 0;
          PfoertnerAus := '';
          sDatum := ToDay;
          eDatum := ToDay;
        end;
        BesucherListeForm.items.insert(0, OneLine);
      end;

    if ListeChanged then
      BesucherListeForm.items.SaveToFile(MyProgramPath + cListeFName);
    FileSetAttr(MyProgramPath + cListeFName, faReadOnly);
    iTransactionServer := true;

    Wochenbesucher.SaveToFile(MyProgramPath + 'Wochenbesucher.ini');

    // Jetzt das Neuladen der neue Liste.ini erzwingen!
    ProgressBar2.position := 55;
    BesucherListeForm.LoadFileData;

    // 3) Zu der Historie.ini hinzufügen
    ProgressBar2.position := 60;
    AppendStringsToFile(HistorieNews, MyProgramPath + iHistorieFName);

    // 4) Besucher-Änderungen / Neuanlage / Löschungen durchführen
    ProgressBar2.position := 65;
    OldBesucher.LoadfromFile(MyProgramPath + cBesucherFName);
    for n := 0 to pred(OutListe.count) do
    begin

      // alten Datensatz suchen
      BesucherTANFound := false;
      id := OutListe[n].BesucherID;
      for m := 0 to pred(OldBesucher.count) do
        if (id = OldBesucher[m].tan) then
        begin
          // gefunden -> kopieren
          BesucherTANFound := true;
          CopyHistorieToBesucher(OutListe[n], OldBesucher[m]);
          break;
        end;

      // Neuanlage
      if not(BesucherTANFound) then
      begin
        NewBesucher := TBesucherItem.Create;
        CopyHistorieToBesucher(OutListe[n], NewBesucher);
        OldBesucher.add(NewBesucher);
      end;

    end;

    // 5) Besucher löschen, die in den Listen stehen!
    ProgressBar2.position := 70;
    dir(MyProgramPath + 'Besucher Löschen *.txt', DelBesucherFiles, false);
    for f := 0 to pred(DelBesucherFiles.count) do
    begin
      ActFname := MyProgramPath + DelBesucherFiles[f];
      DelBesucher.LoadfromFile(ActFname);
      DelBesucher.sorted := true;
      for m := pred(OldBesucher.count) downto 0 do
        if DelBesucher.indexof(inttostr(OldBesucher[m].tan)) <> -1 then
          OldBesucher.delete(m);
      FileDelete(ActFname);
    end;
    WillkommenForm.BesucherLoeschen.clear;

    // 6) ok, Besucher jetzt speichern
    ProgressBar2.position := 75;
    OldBesucher.SaveToFile(MyProgramPath + cBesucherFName);

    // 6) Besucher sortiert speichern
    ProgressBar2.position := 80;
    HistorieNews.LoadfromFile(MyProgramPath + cBesucherFName);
    HistorieNews.sort;
    HistorieNews.SaveToFile(MyProgramPath + cBesucherFName);

    // 7) Besucher - Index neu anlegen
    ProgressBar2.position := 85;
    BesucherIndexErzeugen;

    // 8) Objekte freilassen
    ProgressBar2.position := 90;
    HistorieNews.free;
    OldBesucher.free;
    OutListe.free;
    DelBesucher.free;
    DelBesucherFiles.free;
    Wochenbesucher.free;

    // 9) Mitarbeiter importieren
    ProgressBar2.position := 95;
    if iPLEAImport then
      Button18Click(Sender);
    if iADCMImport then
      Button1Click(Sender);
    if iSCHEMAImport then
      Button26Click(Sender);

    ProgressBar2.position := 0;
    screen.cursor := crdefault;
    close;
  end
  else
  begin
    ShowMessage('Tagesabschluss nur durch den Transaktions-Server möglich!');
  end;
end;

procedure TFormSystemSettings.Timer1Timer(Sender: TObject);
begin
  if iTagesAbschluss <> 0 then
    if not(TagesAbschluss) then
    begin
      if secondstostr5(BesucherListeForm.GetPfortenTime)
        = secondstostr5(iTagesAbschluss) then
      begin
        TagesAbschluss := true;
        show;
        Button17Click(Sender);
      end;
    end
    else
    begin
      if secondstostr5(BesucherListeForm.GetPfortenTime) <>
        secondstostr5(iTagesAbschluss) then
        TagesAbschluss := false;
    end;
end;

procedure TFormSystemSettings.Button18Click(Sender: TObject);
var
  csvAll: TStringList;
  NewMitarbeiter: TStringList;
  OneStr: string;
  _Name: string;
  _tel: string;
  _handy: string;
  _geb: string;
  _email: string;
  n: integer;
begin
  NewMitarbeiter := TStringList.Create;
  csvAll := TStringList.Create;
  csvAll.LoadfromFile(MyProgramPath + 'mitarbeiter.csv');
  ProgressBar1.Max := csvAll.count;
  for n := 0 to pred(csvAll.count) do
  begin
    ProgressBar1.position := n;
    OneStr := csvAll[n];

    NextP(OneStr, ';'); // BSL

    _geb := NextP(OneStr, ';');
    _Name := cutblank(NextP(OneStr, ';')) + ', ' + cutblank(NextP(OneStr, ';'));

    _tel := cutblank(NextP(OneStr, ';'));

    // Fax überlesen!
    NextP(OneStr, ';');

    _handy := cutblank(NextP(OneStr, ';'));
    _email := cutblank(NextP(OneStr, ';'));

    if (_tel <> '') then
    begin
      if pos('+49', _tel) = 1 then
      begin
        ersetze('+49', '', _tel);
        _tel := cutblank(_tel);
      end;

      if pos('07251', _tel) = 1 then
      begin
        ersetze('07251', '', _tel);
        _tel := cutblank(_tel);
      end;

      if pos('7251', _tel) = 1 then
      begin
        ersetze('7251', '', _tel);
        _tel := cutblank(_tel);
      end;

      if pos('73', _tel) = 1 then
      begin
        ersetze('73', '', _tel);
        _tel := cutblank(_tel);
      end;

      _tel := '-' + _tel;
    end;

    if (_handy <> '') then
    begin

      if pos('+49', _handy) = 1 then
      begin
        ersetze('+49', '', _handy);
        _handy := cutblank(_handy);
      end;

      if pos('1', _handy) = 1 then
      begin
        _handy := '0' + _handy;
      end;

      if pos('07251', _handy) = 1 then
      begin
        ersetze('07251', '', _handy);
        _handy := cutblank(_handy);
      end;

      if pos('7251', _handy) = 1 then
      begin
        ersetze('7251', '', _handy);
        _handy := cutblank(_handy);
      end;

      if pos('73', _handy) = 1 then
      begin
        ersetze('73', '', _handy);
        _handy := cutblank(_handy);
      end;

    end;

    while true do
    begin

      if (_handy <> '') and (_tel <> '') then
      begin
        _tel := _tel + ' (' + _handy + ')';
        break;
      end;

      if (_handy <> '') and (_tel = '') then
      begin
        _tel := _handy;
        break;
      end;

      break;

    end;

    OneStr := _Name + ';' + _geb + ';' + _tel + ';' + _email;
    NewMitarbeiter.add(OneStr);
  end;

  NewMitarbeiter.sort;
  NewMitarbeiter.SaveToFile(MyProgramPath + 'Mitarbeiter aus Import.txt');
  NewMitarbeiter.free;
  csvAll.free;
  Button14Click(Sender);
  ProgressBar1.position := 0;
end;

procedure TFormSystemSettings.Button2Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besucher Hinweise ES.txt');
end;

procedure TFormSystemSettings.Button6Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besucher Hinweise PO.txt');
end;

procedure TFormSystemSettings.Button8Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Besucher Hinweise FR.txt');
end;

procedure TFormSystemSettings.Button1Click(Sender: TObject);
var
  AllMitarbeiter: TStringList;
  gateFMitarbeiter: TStringList;
  InpStr: string;
  n: integer;
  _Vorname: string;
  _NachName: string;
  _Ort: string;
  _tel: string;
  _mobile: string;
  _email: string;
  _Abteilung: string;

  function NoSemi(const s: string): string;
  begin
    result := s;
    ersetze(';', '', result);
  end;

begin
  if not(FileExists(iADCMFName)) then
  begin
    ShowMessage('Datei "' + iADCMFName + '" nicht gefunden!');
  end
  else
  begin
    AllMitarbeiter := TStringList.Create;
    gateFMitarbeiter := TStringList.Create;
    AllMitarbeiter.LoadfromFile(iADCMFName);
    ProgressBar1.Max := AllMitarbeiter.count;
    for n := 0 to pred(AllMitarbeiter.count) do
    begin

      InpStr := AllMitarbeiter[n];
      if (length(InpStr) < 10) then
        continue;
      if not(InpStr[1] in ['0' .. '9']) then
        continue;

      NextP(InpStr, ',');
      _NachName := cutblank(copy(NextP(InpStr, '","'), 2, MaxInt));
      _Vorname := cutblank(NextP(InpStr, '","'));
      NextP(InpStr, '","');
      _Abteilung := cutblank(NextP(InpStr, '","'));
      _Ort := _Abteilung;
      _Abteilung := NextP(_Abteilung, ' ');
      _tel := cutblank(NextP(InpStr, '","'));
      NextP(InpStr, '","');
      _mobile := cutblank(NextP(InpStr, '","'));
      _email := '';

      if _mobile <> '' then
        _tel := _tel + ' (' + _mobile + ')';
      if _email = '' then
        _email := _Vorname + '.' + _NachName + '@' + ansilowercase(_Abteilung) +
          '.siemens.de';
      gateFMitarbeiter.add(NoSemi(_NachName + ', ' + _Vorname) + ';' +
        NoSemi(_Ort) + ';' + NoSemi(_tel) + ';' + NoSemi(_email));
    end;
    gateFMitarbeiter.SaveToFile(MyProgramPath + 'Mitarbeiter aus Import.txt');
    gateFMitarbeiter.free;
    AllMitarbeiter.free;
  end;
  Button14Click(Sender);
end;

function TFormSystemSettings.IsKFZKennzeichen(s: string): boolean;
var
  limiter: integer;
  CharLen: integer;
begin
  limiter := 0;
  inc(limiter, CharCount(' ', s));
  inc(limiter, CharCount('-', s));
  CharLen := length(StrFilter(AnsiUpperCase(s), cKFZFilter, false));
  result := (limiter >= 2) and (CharLen <= 9);
end;

procedure TFormSystemSettings.Button19Click(Sender: TObject);
var
  BesucherL: TBesucherList;
  ToDeleteInfo: TStringList;
  NextCheck: integer;
  delCount: integer;

  function FindOne: boolean;
  var
    n, m: integer;
  begin
    result := false;
    for n := NextCheck to pred(BesucherL.count) do
    begin
      for m := 0 to pred(BesucherL.count) do
      begin
        if n <> m then
        begin
          if BesucherL[n].identisch(BesucherL[m]) then
          begin
            inc(delCount);
            Label10.caption := inttostr(delCount);
            application.processmessages;
            ToDeleteInfo.add('');
            ToDeleteInfo.add(BesucherL[n].SaveToString);
            ToDeleteInfo.add(BesucherL[m].SaveToString);
            BesucherL.delete(m);
            result := true;
            exit;
          end;
        end;
      end;
      NextCheck := n;
    end;
  end;

begin
  screen.cursor := crHourGlass;
  ToDeleteInfo := TStringList.Create;
  BesucherL := TBesucherList.Create;
  BesucherL.LoadfromFile(MyProgramPath + cBesucherFName);
  NextCheck := 0;
  delCount := 0;
  Label10.caption := inttostr(delCount);
  application.processmessages;
  while (FindOne) do;

  ToDeleteInfo.SaveToFile(MyProgramPath + 'Besucher dopplet.txt');
  ToDeleteInfo.free;

  BesucherL.SaveToFile(MyProgramPath + cBesucherFName);
  BesucherL.free;
  screen.cursor := crdefault;

end;

procedure TFormSystemSettings.Button20Click(Sender: TObject);
var
  BesucherL: TBesucherList;
  HistorieL: TLineList;

  NewBesucherL: TStringList;
  ZeroBesucherL: TStringList;

  n, m: integer;
  FoundIt: boolean;
  FoundTAN: string;
  StartTime: dword;
  NewTans: integer;
  MissedTANs: integer;
begin
  StartTime := 0;
  NewTans := 0;
  MissedTANs := 0;
  BesucherL := TBesucherList.Create;
  HistorieL := TLineList.Create;
  NewBesucherL := TStringList.Create;
  ZeroBesucherL := TStringList.Create;

  //
  HistorieL.LoadfromFile(MyProgramPath + iHistorieFName);
  BesucherL.LoadfromFile(MyProgramPath + cBesucherFName);
  ProgressBar3.Max := BesucherL.count;
  for n := 0 to pred(BesucherL.count) do
  begin
    if (BesucherL[n].tan = 0) then
    begin
      // TAN in der Historie suchen!
      FoundIt := false;
      with BesucherL[n] do
        for m := pred(HistorieL.count) downto 0 do
          if (Name = cutblank(HistorieL[m].BesucherName)) and
            (firma = cutblank(HistorieL[m].firma)) and
            (kennzeichen = cutblank(HistorieL[m].kennzeichen)) and
            (grund = cutblank(HistorieL[m].grund)) and
            (Handy = cutblank(HistorieL[m].Handy)) and
            (anrede = cutblank(HistorieL[m].anrede)) then
          begin
            FoundIt := true;
            BesucherL[n].datum := HistorieL[m].sDatum;
            BesucherL[n].tan := HistorieL[m].TrnID;
            BesucherL[n].nation := HistorieL[m].Land;
            BesucherL[n].symbol := HistorieL[m].symbol;
            NewBesucherL.add(BesucherL[n].SaveToString);
            inc(NewTans);
            break;
          end;
      if not(FoundIt) then
      begin
        inc(MissedTANs);
        BesucherL[n].tan := NewTrn;
        BesucherL[n].datum := DateGet;
        ZeroBesucherL.add(BesucherL[n].SaveToString);
      end;
    end
    else
    begin
      NewBesucherL.add(BesucherL[n].SaveToString);
    end;

    if frequently(StartTime, 400) or (n = pred(BesucherL.count)) then
    begin
      ProgressBar3.position := n;
      application.processmessages;
    end;
  end;

  BesucherL.free;
  HistorieL.free;

  NewBesucherL.sort;
  NewBesucherL.SaveToFile(MyProgramPath + cBesucherFName);
  NewBesucherL.free;

  ZeroBesucherL.sort;
  ZeroBesucherL.SaveToFile(MyProgramPath + 'Besucher unbenutzt.txt');
  ZeroBesucherL.free;

  ProgressBar3.position := 0;
end;

procedure TFormSystemSettings.BesucherIndexErzeugen;
var
  Besucher: TStringList;
  BesucherIndexL: TStringList;
  BesucherIndex: TWordIndex;
  InpStr: string;
  n: integer;
begin
  BesucherIndexL := TStringList.Create;
  Besucher := TStringList.Create;
  Besucher.LoadfromFile(MyProgramPath + cBesucherFName);
  for n := 0 to pred(Besucher.count) do
  begin
    InpStr := Besucher[n];
    BesucherIndexL.Addobject(NextP(InpStr, ';') + ' ' + NextP(InpStr, ';') + ' '
      + AnsiUpperCase(NextP(InpStr, ';')), TObject(n));
  end;
  BesucherIndex := TWordIndex.Create(BesucherIndexL, 1);
  BesucherIndex.SaveToFile(MyProgramPath + 'Besucher.idx');
  BesucherIndex.free;
  Besucher.free;
  BesucherIndexL.free;
end;

procedure TFormSystemSettings.Button21Click(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  BesucherIndexErzeugen;
  screen.cursor := crdefault;
end;

procedure TFormSystemSettings.Button22Click(Sender: TObject);
var
  Besucher: TBesucherList;
  Nummern: TStringList;
  n: integer;
  NummernDoppelt: TStringList;
  _tan: string;
begin
  screen.cursor := crHourGlass;
  NummernDoppelt := TStringList.Create;
  Nummern := TStringList.Create;
  Besucher := TBesucherList.Create;
  Besucher.LoadfromFile(MyProgramPath + cBesucherFName);

  for n := pred(Besucher.count) downto 0 do
  begin
    _tan := inttostr(Besucher[n].tan);
    if (Nummern.indexof(_tan) = -1) and (Besucher[n].tan > 0) then
    begin
      Nummern.Addobject(_tan, TObject(n));
    end
    else
    begin
      NummernDoppelt.Addobject(_tan, TObject(n));
      with Besucher[n] do
      begin
        name := '';
        firma := '';
        kennzeichen := '';
      end;
    end;
  end;

  if (NummernDoppelt.count > 0) then
  begin
    Besucher.SaveToFile(MyProgramPath + cBesucherFName);
    NummernDoppelt.SaveToFile(MyProgramPath + 'Besucher Nummer doppelt.txt');
    openShell(MyProgramPath + 'Besucher Nummer doppelt.txt');
  end
  else
  begin
    ShowMessage('keine Doppelten!');
  end;
  Besucher.free;
  NummernDoppelt.free;
  Nummern.free;
  screen.cursor := crdefault;
end;

procedure TFormSystemSettings.Button23Click(Sender: TObject);
var
  Besucher: TBesucherList;
  BesucherS: TStringList;
  n: integer;
begin
  Besucher := TBesucherList.Create;
  Besucher.LoadfromFile(MyProgramPath + cBesucherFName);
  Besucher.SaveToFile(MyProgramPath + cBesucherFName);
  Besucher.free;

  BesucherS := TStringList.Create;
  BesucherS.LoadfromFile(MyProgramPath + cBesucherFName);
  BesucherS.sort;
  RemoveDuplicates(BesucherS, n);
  ShowMessage(inttostr(n) + ' doppelte sind raus!');
  BesucherS.SaveToFile(MyProgramPath + cBesucherFName);
  BesucherS.free;
end;

procedure TFormSystemSettings.Button24Click(Sender: TObject);
var
  Besucher: TStringList;
  Nummern: TStringList;
  n: integer;
begin
  Nummern := TStringList.Create;
  Besucher := TStringList.Create;
  Besucher.LoadfromFile(MyProgramPath + cBesucherFName);
  for n := 0 to pred(Besucher.count) do
    Nummern.add(NextP(Besucher[n], ';', 8));
  Nummern.sort;
  RemoveDuplicates(Nummern, n);
  ShowMessage(inttostr(n) + ' doppelte!');
  Besucher.free;
  Nummern.free;
end;

procedure TFormSystemSettings.Button25Click(Sender: TObject);
begin
  openShell(MyProgramPath + cMitarbeiterFName);
end;

procedure TFormSystemSettings.Button26Click(Sender: TObject);
var
  RID_AT_IMPORT: integer;
  gateFMitarbeiter: TStringList;
  QuellStrings: TStringList;
  _Vorname: string;
  _Name: string;
  _NachName: string;
  _Ort: string;
  _Fest: string;
  _handy: string;
  _tel: string;
  _email: string;
  n: integer;
  InpStr: string;
begin
  RID_AT_IMPORT := FormImport.Execute('gateF');

  if (RID_AT_IMPORT <> -1) then
  begin
    // Datensicherung der alten Mitarbeiter.txt
    if FileExists(MyProgramPath + cMitarbeiterFName) then
      FileCopy(MyProgramPath + cMitarbeiterFName,
        ImportePath + inttostr(RID_AT_IMPORT) + '\Bisherige ' +
        cMitarbeiterFName);
  end;

  gateFMitarbeiter := TStringList.Create;
  QuellStrings := TStringList.Create;
  QuellStrings.LoadfromFile(ImportePath + inttostr(RID_AT_IMPORT) +
    '\Resultat.csv');
  for n := 0 to pred(QuellStrings.count) do
  begin
    InpStr := QuellStrings[n];
    _NachName := NextP(InpStr, ';');
    _Vorname := NextP(InpStr, ';');

    if (_Vorname <> '') and (_NachName <> '') then
      _Name := _NachName + ', ' + _Vorname
    else
      _Name := _NachName + _Vorname;

    _Ort := NextP(InpStr, ';');
    _tel := NextP(InpStr, ';');
    _handy := NextP(InpStr, ';');
    _email := NextP(InpStr, ';');
    if (_handy <> '') then
      _tel := _tel + ' (' + _handy + ')';

    gateFMitarbeiter.add(_Name + ';' + _Ort + ';' + _tel + ';' + _email);
  end;
  gateFMitarbeiter.SaveToFile(MyProgramPath + 'Mitarbeiter aus Import.txt');
  gateFMitarbeiter.free;
  Button14Click(Sender);
end;

procedure TFormSystemSettings.Button27Click(Sender: TObject);
begin
  FormImport.show;
end;

end.
