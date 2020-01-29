{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011 - 2020  Andreas Filsinger
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
unit BelegSuche;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, Grids, ComCtrls,
  Buttons,

  // Tools
  gplists,

  // IBO
  IB_Access,
  IB_Components,
  IB_Controls,
  IB_Grid,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar, JvComponentBase, JvFormPlacement;

type
  TFormBelegSuche = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    SpeedButton9: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton41: TSpeedButton;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    IB_SearchBar1: TIB_SearchBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button1: TButton;
    ComboBox1: TComboBox;
    Button4: TButton;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Button7: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Query4: TIB_Query;
    Button18: TButton;
    Panel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    IB_Grid3: TIB_Grid;
    Button2: TButton;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_Query5: TIB_Query;
    OpenDialog1: TOpenDialog;
    IB_SearchBar3: TIB_SearchBar;
    IB_NavigationBar3: TIB_NavigationBar;
    IB_UpdateBar3: TIB_UpdateBar;
    Button9: TButton;
    Button8: TButton;
    JvFormStorage1: TJvFormStorage;
    Splitter1: TSplitter;
    SpeedButton13: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure IB_Query3AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure IB_Query3BeforePrepare(Sender: TIB_Statement);
    procedure SpeedButton20Click(Sender: TObject);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
      AFont: TFont);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton41Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ItemRIDs: TgpIntegerList;
    cCOL_PAPERCOLOR: Integer;

    procedure EnsureQueriesAreOpen;
  public
    { Public-Deklarationen }
    procedure PrepareNewQuery;
    procedure setContext(BELEG_R: Integer);
  end;

var
  FormBelegSuche: TFormBelegSuche;

implementation

uses
  anfix32, CareTakerClient, wanfix32,
  html,

  globals,
  Person,
  Belege,
  AusgangsRechnungen,
  Funktionen_LokaleDaten,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  ArtikelVerlag, Lager, WarenBewegung,
  dbOrgaMon,  main, Datenbank, GUIHelp;

{$R *.DFM}

procedure TFormBelegSuche.Button18Click(Sender: TObject);
var
  PERSON_R: Integer;
begin
  PERSON_R := IB_Query1.FieldByName('PERSON_R').AsInteger;
  e_w_KontoInfo(PERSON_R).free;
  openShell(e_r_MahnungFName(PERSON_R));
end;

procedure TFormBelegSuche.Button1Click(Sender: TObject);
begin
  if (IB_Memo1.height > 10) then
  begin
    IB_Memo1.width := 21;
    IB_Memo1.height := 5;
    Button1.Caption := '&I+';
  end
  else
  begin
    IB_Memo1.width := 400;
    IB_Memo1.height := 200;
    Button1.Caption := '&I-';
  end;
end;

procedure TFormBelegSuche.FormActivate(Sender: TObject);
begin
  EnsureQueriesAreOpen;
end;

var
  LastRow: Integer = -1;
  LastBackgroundCol: TColor;
  LastFontCol: TColor;

procedure TFormBelegSuche.IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState;
  var AColor: TColor; AFont: TFont);
var
  PAPERCOLOR: string;
begin

  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid1 do
    begin
      if (ARow <> LastRow) then
      begin

        // Spalte der "PAPERCOLOR" bestimmen
        if (cCOL_PAPERCOLOR <= 0) then
          cCOL_PAPERCOLOR := ColOfGrid(IB_Grid1, 'PAPERCOLOR');
        if (cCOL_PAPERCOLOR <= 0) then
          raise Exception.create('Spalte "PAPERCOLOR" ist undefiniert!');

        // Wert aus PAPERCOLOR bestimmen
        PAPERCOLOR := GetCellDisplayText(cCOL_PAPERCOLOR, ARow);
        if (PAPERCOLOR <> '') then
          LastBackgroundCol := strtointdef(PAPERCOLOR, color)
        else
          LastBackgroundCol := color;

        //
        LastFontCol := VisibleContrast(LastBackgroundCol);

        // Cache-Flag setzen
        LastRow := ARow;
      end;

      AColor := LastBackgroundCol;
      AFont.color := LastFontCol;
    end;

end;

procedure TFormBelegSuche.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;
  IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
  if IB_Query1.FieldByName('LAGER_R').IsNull then
    Label3.Caption := '---'
  else
    Label3.Caption := e_r_LagerPlatzNameFromLAGER_R(IB_Query1.FieldByName('LAGER_R').AsInteger);
  Label5.Caption := e_r_Person(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBelegSuche.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  cCOL_PAPERCOLOR := 0;
end;

procedure TFormBelegSuche.Button3Click(Sender: TObject);
begin
  FormBelege.setContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
  FormBelege.show;
  application.processmessages;
  FormBelege.IB_Query1.Locate('RID', IB_Query1.FieldByName('RID').AsInteger, []);
end;

procedure TFormBelegSuche.ComboBox1Change(Sender: TObject);
begin
  PrepareNewQuery;
end;

procedure TFormBelegSuche.Button4Click(Sender: TObject);
var
  MyList: THTMLTemplate;
  even: boolean;
  S_RB: double;
  S_DB: double;
  S_OF: double;
  Rechnungs_Betrag: double;
  Davon_Bezahlt: double;
  _AddStr: string;
begin
  BeginHourGlass;
  MyList := THTMLTemplate.create;
  MyList.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Beleg Liste.html');

  // ZEILE EVEN
  // ZEILE ODD
  even := true;
  S_RB := 0.0;
  S_DB := 0.0;
  S_OF := 0.0;

  IB_Query2.DisableControls;
  IB_Query3.DisableControls;
  IB_Query4.DisableControls;

  with IB_Query1, MyList do
  begin
    ProgressBar1.Step := 1;
    ProgressBar1.max := RecordCount;
    ProgressBar1.position := 0;

    DisableControls;
    SaveBlockToFile('ZEILE EVEN', MyProgramPath + cHTMLBlocksDir + 'SUBITEM ZEILE EVEN.html');
    SaveBlockToFile('ZEILE ODD', MyProgramPath + cHTMLBlocksDir + 'SUBITEM ZEILE ODD.html');
    ClearBlock('ZEILE EVEN');
    ClearBlock('ZEILE ODD');
    first;
    while not(eof) do
    begin
      { welche Zeile soll geladen werden! }
      if even then
        LoadBlockFromFile('MERKER', MyProgramPath + cHTMLBlocksDir + 'SUBITEM ZEILE EVEN.html')
      else
        LoadBlockFromFile('MERKER', MyProgramPath + cHTMLBlocksDir + 'SUBITEM ZEILE ODD.html');
      even := not(even);

      Rechnungs_Betrag := FieldByName('RECHNUNGS_BETRAG').AsDouble;
      Davon_Bezahlt := FieldByName('DAVON_BEZAHLT').AsDouble;

      WriteValueOnce('RID', inttostr(FieldByName('RID').AsInteger));
      WriteValueOnce('vom', FieldByName('ANLAGE').AsString);

      // komplette Anschrift laden!
      IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;
      IB_Query4.ParamByName('CROSSREF').AsInteger := IB_Query2.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;

      _AddStr :=
        {} IB_Query2.FieldByName('VORNAME').AsString + ' ' + IB_Query2.FieldByName('NACHNAME').AsString +
        {} ' (' + IB_Query2.FieldByName('NUMMER').AsString + ') ' + #13 +
        {} IB_Query4.FieldByName('NAME1').AsString + #13 +
        {} IB_Query4.FieldByName('STRASSE').AsString + #13 +
        {} HugeSingleLine(e_r_ort(IB_Query4),#13,MaxInt,true);

      WriteValueOnce('Anschrift', _AddStr);
      WriteValueOnce('RB', format('%.2m', [Rechnungs_Betrag]));
      WriteValueOnce('DB', format('%.2m', [Davon_Bezahlt]));
      WriteValueOnce('OF', format('%.2m', [Rechnungs_Betrag - Davon_Bezahlt]));

      S_RB := S_RB + Rechnungs_Betrag;
      S_DB := S_DB + Davon_Bezahlt;
      S_OF := S_OF + (Rechnungs_Betrag - Davon_Bezahlt);
      next;
      ProgressBar1.StepIt;
    end;
    WriteValue('S_RB', format('%.2m', [S_RB]));
    WriteValue('S_DB', format('%.2m', [S_DB]));
    WriteValue('S_OF', format('%.2m', [S_OF]));
    EnableControls;
    first;
  end;
  MyList.SaveToFile(MyProgramPath + 'Beleg Liste.html');
  MyList.free;
  IB_Query2.EnableControls;
  IB_Query3.EnableControls;
  IB_Query4.EnableControls;
  ProgressBar1.position := 0;
  EndHourGlass;
  openShell(MyProgramPath + 'Beleg Liste.html');
end;

procedure TFormBelegSuche.Button2Click(Sender: TObject);
begin
  FormPerson.setContext(IB_Query2.FieldByName('RID').AsInteger);
end;

procedure TFormBelegSuche.Button7Click(Sender: TObject);
begin
  with IB_Query1 do
    FormAusgangsrechnungen.setContext(FieldByName('PERSON_R').AsInteger, FieldByName('RID').AsInteger,
      FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble);
end;

function nosemi(const s: string): string;
begin
  result := s;
  ersetze(';', ',', result);
end;

procedure TFormBelegSuche.Button8Click(Sender: TObject);
begin
  e_w_BelegStatusBuchen(IB_Query1.FieldByName('RID').AsInteger);
  IB_Query1.Refresh;
  IB_Query2.Refresh;
  IB_Query3.Refresh;
end;

procedure TFormBelegSuche.PrepareNewQuery;
var
  n, k: Integer;
  cVersandfaehigEntry: string;
  cFehlerHaftEntry: string;
  cAlleStatusEntry: string;
  cVersandfertigEntry: string;
  cUngeliefert: string; // enthält ungelieferte Artikel
  cAbgewickelt: string; //
  cStdEntry: string;
  cOffeneEntry: string;
  cFaelligeEntry: string;
  cUebergangsFachEntry: string;
  cTerminierte: string;
  cSelectFields: string;
  cErwartet: string;
  cUngebucht: string;
  cMahnung1: string;
  cMahnung2: string;
  cMahnung3: string;
  cMahnBescheid: string;
  cMahnungAusgesetzt: string;
  cOLAPEntry: string;

  procedure AddLines(s: string; StrList: TStrings);
  begin
    StrList.clear;
    while (s <> '') do
      StrList.add(nextp(s, #13));
  end;

begin
  BeginHourGlass;
  // extract old Statement
  cSelectFields := '';
  with IB_Query1.SQL do
    for n := 0 to pred(count) do
      if pos('FROM', strings[n]) = 1 then
        break
      else
        cSelectFields := cSelectFields + #13 + strings[n];

  cStdEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'ORDER BY RID' + #13 + 'FOR UPDATE';

  cOffeneEntry := cSelectFields + #13 + 'FROM BELEG ' + #13 + 'WHERE ' + #13 + ' (RECHNUNGS_BETRAG>0.0) and ' + #13 +
    ' ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) or (DAVON_BEZAHLT is null)) ' + #13 + 'ORDER BY RID' + #13 + 'FOR UPDATE';

  cFaelligeEntry := cSelectFields + #13 + 'FROM BELEG' + #13 +
    'WHERE ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) OR (RECHNUNGS_BETRAG>0 AND DAVON_BEZAHLT IS NULL)) AND' + #13 +
    '      (FAELLIG<''' + Long2date(DatePlus(DateGet, -strtoint(Edit1.Text))) + ''')' + #13 + 'ORDER BY RID' + #13 +
    'FOR UPDATE';

  cVersandfaehigEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE MENGE_RECHNUNG>0' + #13 + 'ORDER BY RID' +
    #13 + 'FOR UPDATE';

  cVersandfertigEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE' + #13 +
    ' ((MENGE_RECHNUNG>0) AND (MENGE_AGENT=0)) OR' + #13 + ' (TERMIN = ''' + Datum10 + ''')' + #13 +
  //
  // where
  // cast(TERMIN AS DATE) > '01.01.2006'
  //
  //
    'ORDER BY RID' + #13 + 'FOR UPDATE';

  cUngeliefert := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE MENGE_AGENT>0' + #13 + 'ORDER BY RID' + #13 +
    'FOR UPDATE';

  cErwartet := cSelectFields + #13 + 'FROM BELEG' + #13 + 'where RID in ' + #13 + '(select distinct' + #13 +
    ' POSTEN.BELEG_R' + #13 + 'from' + #13 + ' POSTEN' + #13 + 'join' + #13 + ' bposten' + #13 + 'on' + #13 +
    ' (POSTEN.artikel_r=bposten.artikel_R) and' + #13 +
    ' ((POSTEN.ausgabeart_r=bposten.ausgabeart_r) or ((POSTEN.ausgabeart_r is null) and (BPOSTEN.ausgabeart_r is null))) and'
    + #13 + ' (BPOSTEN.MENGE_ERWARTET>0)' + #13 + 'where' + #13 + ' (MENGE_AGENT>0)' + #13 + ')' + #13 + 'ORDER BY RID'
    + #13 + 'FOR UPDATE';

  cFehlerHaftEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE VERSAND_STATUS>=' +
    inttostr(cV_Fehler + cV_ZeroState) + #13 + 'ORDER BY RID' + #13 + 'FOR UPDATE';

  cAlleStatusEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'ORDER BY RID' + #13 + 'FOR UPDATE';

  cAbgewickelt := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE MENGE_AUFTRAG=MENGE_GELIEFERT' + #13 +
    'ORDER BY RID' + #13 + 'FOR UPDATE';

  cUebergangsFachEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE NOT(LAGER_R IS NULL)' + #13 +
    'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cMahnung1 := cSelectFields + #13 + 'FROM BELEG' + #13 +
    'WHERE ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) OR (RECHNUNGS_BETRAG>0 AND DAVON_BEZAHLT IS NULL)) AND' + #13 +
    '      (mahnung1 is not null) and (mahnung2 is null) and (mahnung3 is null) and (mahnbescheid is null)' +
    'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cMahnung2 := cSelectFields + #13 + 'FROM BELEG' + #13 +
    'WHERE ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) OR (RECHNUNGS_BETRAG>0 AND DAVON_BEZAHLT IS NULL)) AND' + #13 +
    '      (mahnung1 is not null) and (mahnung2 is not null) and (mahnung3 is null) and (mahnbescheid is null)' +
    'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cMahnung3 := cSelectFields + #13 + 'FROM BELEG' + #13 +
    'WHERE ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) OR (RECHNUNGS_BETRAG>0 AND DAVON_BEZAHLT IS NULL)) AND' + #13 +
    '      (mahnung1 is not null) and (mahnung2 is not null) and (mahnung3 is not null) and (mahnbescheid is null)' +
    'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cMahnBescheid := cSelectFields + #13 + 'FROM BELEG' + #13 +
    'WHERE ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) OR (RECHNUNGS_BETRAG>0 AND DAVON_BEZAHLT IS NULL)) AND' + #13 +
    '      (mahnbescheid is not null)' + #13 + 'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cMahnungAusgesetzt := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE (MAHNUNG_AUSGESETZT=''Y'')' + #13 +
    'ORDER BY ANLAGE' + #13 + 'FOR UPDATE';

  cTerminierte := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE (TERMIN IS NOT NULL)' + #13 + 'ORDER BY TERMIN' +
    #13 + 'FOR UPDATE';

  cUngebucht := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE (RECHNUNGS_BETRAG is null) or' + #13 +
    '(RECHNUNG is null)' + #13 + 'ORDER BY RID descending' + #13 + 'FOR UPDATE';

  cOLAPEntry := cSelectFields + #13 + 'FROM BELEG' + #13 + 'WHERE RID in ' + ListasSQL(ItemRIDs) + #13 + 'ORDER BY RID'
    + #13 + 'FOR UPDATE';

  with IB_Query1 do
  begin
    Close;
    k := ComboBox1.items.indexof(ComboBox1.Text);
    case k of
      1:
        AddLines(cUngebucht, SQL);
      2:
        AddLines(cOffeneEntry, SQL);
      3:
        AddLines(cFaelligeEntry, SQL);
      4:
        AddLines(cVersandfaehigEntry, SQL);
      5:
        AddLines(cVersandfertigEntry, SQL);
      6:
        AddLines(cUngeliefert, SQL);
      7:
        AddLines(cErwartet, SQL);
      8:
        AddLines(cAbgewickelt, SQL);
      9:
        AddLines(cFehlerHaftEntry, SQL);
      10:
        AddLines(cAlleStatusEntry, SQL);
      11:
        AddLines(cUebergangsFachEntry, SQL);
      12:
        AddLines(cMahnung1, SQL);
      13:
        AddLines(cMahnung2, SQL);
      14:
        AddLines(cMahnung3, SQL);
      15:
        AddLines(cMahnBescheid, SQL);
      16:
        AddLines(cMahnungAusgesetzt, SQL);
      17:
        AddLines(cOLAPEntry, SQL);
      18:
        AddLines(cTerminierte, SQL);
    else
      AddLines(cStdEntry, SQL);
    end;
    // sql.SaveToFile(LogDir+'SQL Belegsuche.txt');
    Active := true;
  end;

  IB_Grid1.SetFocus;
  EndHourGlass;
end;

procedure TFormBelegSuche.setContext(BELEG_R: Integer);
begin
  BeginHourGlass;
  EnsureQueriesAreOpen;
  show;
  IB_Query1.Locate('RID', BELEG_R, []);
  EndHourGlass;
end;

procedure TFormBelegSuche.Edit1Exit(Sender: TObject);
begin
  PrepareNewQuery;
end;

procedure TFormBelegSuche.EnsureQueriesAreOpen;
begin
  if (ComboBox1.items.count = 0) then
  begin
    ItemRIDs := TgpIntegerList.create;
    ComboBox1.items.add('Standard');
    ComboBox1.items.add('ungebucht');
    ComboBox1.items.add('offene Posten');
    ComboBox1.items.add('fällige Posten');
    ComboBox1.items.add('versandfähig (teilweise da)');
    ComboBox1.items.add('versandfertig (alles da)');
    ComboBox1.items.add('unvollständig (Agent>0)');
    ComboBox1.items.add('erwartet (Bestellung drausen)');
    ComboBox1.items.add('abgewickelt');
    ComboBox1.items.add('Buchungsfehler');
    ComboBox1.items.add('Alle Status');
    ComboBox1.items.add('im Übergangsfach');
    ComboBox1.items.add('Mahnung 1');
    ComboBox1.items.add('Mahnung 2');
    ComboBox1.items.add('Mahnung 3');
    ComboBox1.items.add('Mahnbescheid');
    ComboBox1.items.add('Mahnung ausgesetzt');
    ComboBox1.items.add(cOLAP_Ergebnis);
    ComboBox1.items.add('Terminierte');

    ComboBox1.Text := ComboBox1.items[0];
  end;

  if not(IB_Query1.Active) then
    IB_Query1.Open;
  if not(IB_Query2.Active) then
    IB_Query2.Open;
  if not(IB_Query3.Active) then
    IB_Query3.Open;
  if not(IB_Query4.Active) then
    IB_Query4.Open;
end;

procedure TFormBelegSuche.IB_Query3AfterPost(IB_Dataset: TIB_Dataset);
begin
  e_w_BelegStatusBuchen(IB_Query1.FieldByName('RID').AsInteger);
  IB_Query1.Refresh;
  IB_Query2.Refresh;
  IB_Query3.Refresh;
end;

procedure TFormBelegSuche.Button9Click(Sender: TObject);
var
  MENGE: Integer;
  ArtikelInfo: TStringList;
  n: Integer;
  OutL: TStringList;
  StartTime: dword;
  RecN: Integer;
begin
  OutL := TStringList.create;
  ArtikelInfo := TStringList.create;
  IB_Query1.DisableControls;
  IB_Query2.DisableControls;
  IB_Query3.DisableControls;
  ProgressBar1.max := IB_Query1.RecordCount;
  StartTime := 0;
  RecN := 0;
  IB_Query1.first;
  while not(IB_Query1.eof) do
  begin
    IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;
    IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    IB_Query3.first;
    while not(IB_Query3.eof) do
    begin
      MENGE := IB_Query3.FieldByName('MENGE_RECHNUNG').AsInteger;
      if (MENGE > 0) then
      begin

        //
        with IB_Query5 do
        begin

          //
          ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('ARTIKEL_R').AsInteger;
          if not(Active) then
            Open;

          //
          if not(IsEmpty) then
          begin
            FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);
            for n := 1 to MENGE do
              OutL.add(nosemi(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger)) + ';' +
                inttostr(FieldByName('NUMERO').AsInteger) + ';' + nosemi(FieldByName('TITEL').AsString) + ';' +
                inttostr(n) + '/' + inttostr(MENGE) + ';' + nosemi(ArtikelInfo.Values['BEM']) + ';' +
                e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger) + ';' +
                nosemi(ArtikelInfo.Values['VERLAGNO']) + ';' + IB_Query2.FieldByName('NUMMER').AsString + ';' +
                IB_Query1.FieldByName('RID').AsString);
          end;
        end;
      end;
      IB_Query3.next;
    end;
    inc(RecN);
    IB_Query1.next;
    if IB_Query1.eof or (frequently(StartTime, 333)) then
    begin
      ProgressBar1.position := RecN;
      application.processmessages;
    end;
  end;
  IB_Query5.Close;
  IB_Query1.EnableControls;
  IB_Query2.EnableControls;
  IB_Query3.EnableControls;
  OutL.SaveToFile(DiagnosePath + 'Lager Liste 3.txt');
  OutL.free;
  ArtikelInfo.free;
  ProgressBar1.position := 0;
  EndHourGlass;
  openShell(DiagnosePath + 'Lager Liste 3.txt');
end;

procedure TFormBelegSuche.SpeedButton13Click(Sender: TObject);
var
  ARTIKEL: string;
  lVERTRAG_R: TgpIntegerList;
  AutoMataState: Integer;
  VERTRAG_R: Integer;
  VORNAME, NACHNAME: string;
  DATUM: string;
  DATUM_A, DATUM_B: TAnfixDate;
  BEZAHLT_BIS: TDateTime;
  // Namensbearbeitung
  VollerName: string;
  i: Integer;
  sLog: TStringList;
begin

  // erfolgte Zahlung in den Vertrag eintragen -> BEZAHLT_BIS
  AutoMataState := 0;
  lVERTRAG_R := nil;
  VERTRAG_R := cRID_unset;
  sLog := TStringList.create;

  with IB_Query3 do
  begin
    first;
    while not(eof) do
    begin

      while true do
      begin
        case AutoMataState of
          0: // Setze PERSON_R, Set VERTRAG_R
            begin

              // Aufräumen
              if assigned(lVERTRAG_R) then
              begin
                sLog.add('--------------------------------------------------');
                FreeAndNil(lVERTRAG_R);
              end;

              ARTIKEL := FieldByName('ARTIKEL').AsString;

              if FieldByName('MENGE').IsNull then
              begin
                sLog.add('ARTIKEL=' + ARTIKEL);

                //
                VERTRAG_R := strtointdef(nextp(FieldByName('INFO').AsString, '.', 0), cRID_unset);
                sLog.add('VERTRAG_R=' + inttostr(VERTRAG_R));

                if (pos('IMEI', ARTIKEL) > 0) then
                begin

                  VollerName := ExtractSegmentBetween(ARTIKEL, '<i>', ':');
                  i := revpos(' ', VollerName);
                  if (i > 0) then
                  begin
                    VORNAME := copy(VollerName, 1, pred(i));
                    NACHNAME := copy(VollerName, succ(i), MAxInt);
                  end
                  else
                  begin
                    VORNAME := '';
                    NACHNAME := VollerName;
                  end;

                  if (VERTRAG_R > cRID_FirstValid) then
                  begin
                    // Der VERTRAG_R aus INFO immer im Vorrang
                    lVERTRAG_R := TgpIntegerList.create;
                    lVERTRAG_R.add(VERTRAG_R);
                  end
                  else
                  begin
                    // Suche des VERTRAG_R über den Namen des Vertragsnehmern
                    lVERTRAG_R := e_r_sqlm(
                      { } 'select VERTRAG.RID from' +
                      { } ' PERSON ' +
                      { } 'join' +
                      { } ' VERTRAG ' +
                      { } 'on' +
                      { } ' (PERSON.RID=VERTRAG.PERSON_R) and' +
                      { } ' (VERTRAG.BAUSTELLE_R=630) ' +
                      { } 'where' +
                      { } ' (PERSON.VORNAME=' + SQLString(VORNAME) + ') and' +
                      { } ' (PERSON.NACHNAME=' + SQLString(NACHNAME) + ')');
                  end;

                  repeat

                    // Versuchen die Liste zu verkürzen
                    lVERTRAG_R.RemoveDuplicates;

                    if (lVERTRAG_R.count = 0) then
                    begin
                      ShowMessage(
                        { } 'Person "' +
                        { } VORNAME +
                        { } ' ' +
                        { } NACHNAME +
                        { } '" nicht gefunden, oder hat keinen Vertrag mehr!');
                      sLog.add('NICHT_GEFUNDEN=' + cIni_Activate);
                      FreeAndNil(lVERTRAG_R);
                      break;
                    end;

                    if (lVERTRAG_R.count > 1) then
                    begin
                      ShowMessage(
                        { } 'Person "' +
                        { } VORNAME +
                        { } ' ' +
                        { } NACHNAME +
                        { } '": Mehrere Treffer!');
                      sLog.add('MEHRDEUTIG=' + cIni_Activate);
                      FreeAndNil(lVERTRAG_R);
                      break;
                    end;

                    if (VERTRAG_R >= cRID_FirstValid) then
                      if (lVERTRAG_R[0] <> VERTRAG_R) then
                      begin
                        ShowMessage(
                          { } 'Person "' +
                          { } VORNAME +
                          { } ' ' +
                          { } NACHNAME +
                          { } '": Unklare Treffer!');
                        sLog.add('UNKLAR=' + cIni_Activate);
                        FreeAndNil(lVERTRAG_R);
                        VERTRAG_R := cRID_unset;
                        break;
                      end;

                    if (lVERTRAG_R.count = 1) then
                    begin
                      inc(AutoMataState);
                      break;
                    end;

                  until true;
                end;
              end
              else
              begin
                sLog.add('ARTIKEL_IGNORE=' + ARTIKEL);
              end;
            end;
          1: // ermittle das "bis" Datum, Buche wenn nötig
            begin

              if not(assigned(lVERTRAG_R)) then
                raise Exception.create('Im Status 1 muss der Vertagskontext klar sein');

              if (FieldByName('MENGE').IsNotNull) then
              begin
                ARTIKEL := FieldByName('ARTIKEL').AsString;
                DATUM := ExtractSegmentBetween(ARTIKEL, ' - ', ' (');
                if (length(DATUM) = 10) then
                begin

                  DATUM_A := e_r_sql_Date('select BEZAHLT_BIS from VERTRAG where RID=' + inttostr(lVERTRAG_R[0]));
                  DATUM_B := Date2Long(DATUM);

                  sLog.add('DATUM_A=' + Long2date(DATUM_A));
                  sLog.add('DATUM_B=' + Long2date(DATUM_B));

                  // nur ändern wenn aktuelles Datum neuer
                  if (DATUM_B > DATUM_A) then
                  begin

                    // buche es im Vertrag
                    e_x_sql(
                      { } 'update VERTRAG ' +
                      { } 'set BEZAHLT_BIS=' + SQLString(DATUM) + ' ' +
                      { } 'where' +
                      { } ' (RID=' + inttostr(lVERTRAG_R[0]) + ') and ' +
                      { } ' ((BEZAHLT_BIS is null) or' +
                      { } '  (BEZAHLT_BIS < ' + SQLString(DATUM) + '))');

                    // markiere es im Beleg
                    edit;
                    FieldByName('GEWICHT').AsInteger := FieldByName('GEWICHT').AsInteger + 1;
                    post;

                    sLog.add('GEBUCHT=' + cIni_Activate);

                  end;
                end;
              end
              else
              begin
                AutoMataState := 0;
                continue;
              end;
            end;
        end;
        break;
      end;
      next;
    end;
  end;

  sLog.SaveToFile(
    { } DiagnosePath + 'BELEG-' +
    { } IB_Query1.FieldByName('RID').AsString + '-' +
    { } 'Bezahlt' +
    { } cLogExtension);
  sLog.free;
end;

procedure TFormBelegSuche.SpeedButton1Click(Sender: TObject);
begin
  FormWarenbewegung.setContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelegSuche.SpeedButton20Click(Sender: TObject);
begin
  cnBELEG.addContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelegSuche.SpeedButton2Click(Sender: TObject);
begin
  BeginHourGlass;
  e_x_BelegAusPOS;
  EndHourGlass;
end;

procedure TFormBelegSuche.SpeedButton41Click(Sender: TObject);
begin
  if doit('Beleg wirklich stornieren und Artikel wieder einlagern', true) then
  begin
    BeginHourGlass;
    e_w_BelegStorno(IB_Query1.FieldByName('RID').AsInteger);
    IB_Query1.Refresh;
    EndHourGlass;
  end;
end;

procedure TFormBelegSuche.SpeedButton9Click(Sender: TObject);
var
  ImportL: TStringList;
  n, BELEG_R: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);
    ItemRIDs.clear;
    for n := 0 to pred(ImportL.count) do
    begin
      BELEG_R := strtointdef(nextp(ImportL[n], ';', 0), cRID_Null);
      if (BELEG_R >= cRID_FirstValid) then
        ItemRIDs.add(BELEG_R);
    end;
    ImportL.free;
    ComboBox1.ItemIndex := ComboBox1.items.indexof(cOLAP_Ergebnis);
    ComboBox1Change(Sender);
    EndHourGlass;
  end;
end;

procedure TFormBelegSuche.IB_Query3BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid3, AnwenderPath + HeaderSettingsFName(FormBelege.IB_grid2));
end;

end.
