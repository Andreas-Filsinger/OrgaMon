{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Andreas Filsinger
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
unit PersonSuche;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Grids, Datenbank,

  // Tools
  gplists,

  // IBO
  IB_Components,

  // Hebu-Projekt
  wordindex, Buttons, ExtCtrls,
  IB_CursorGrid, IB_Grid, IB_Access, IB_Controls, IB_UpdateBar;

type
  TFormPersonSuche = class(TForm)
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    Button2: TButton;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton27: TSpeedButton;
    Label3: TLabel;
    Image2: TImage;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button7: TButton;
    Button8: TButton;
    Button10: TButton;
    SpeedButton4: TSpeedButton;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Image1: TImage;
    Timer1: TTimer;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Edit2: TEdit;
    Label4: TLabel;
    Button19: TButton;
    Button18: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button24: TButton;
    SpeedButton5: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer;
      var AString: String);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer;
      AState: TGridDrawState; var AColor: TColor; AFont: TFont);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2DblClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private-Deklarationen }
    SearchIndex: TWordIndex;
    GridSQL: TSTringList;
    NoLimit: boolean;
    sTreffer: string;
    sMitglieder: TgpIntegerList;
    GEN_MITGLIEDERLISTE: Integer;
    _TimeRefreshed: dword;
    LastValueByScroll: string;
    // Speichert den Inhalt des aktuell angezeigten Datensatzes

    function Suche_PERSON_R: Integer;

    procedure Suche;
    procedure Nehme;
    procedure NehmeBelege;
    procedure Zeige;
  public
    { Public-Deklarationen }
    DontSetContext: boolean;
    PERSON_R: Integer;
    procedure setContext(s: string);
    procedure AufgabeAdd(Gruppe: string; PERSON_R: Integer);
    procedure AufgabeStatus(Gruppe: string);
    function AuftragGruppe(Gruppe: string): Integer;
    procedure AufgabeRefresh;
    procedure AufgabeAenderungAnzeigen;
  end;

var
  FormPersonSuche: TFormPersonSuche;

implementation

uses
  math, globals, anfix32, Person,
  Jvgnugettext, wanfix32, GUIhelp,
  Funktionen_Auftrag, CareTakerClient,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,
  dbOrgaMon, Belege, BuchBarKasse;

{$R *.DFM}

var
  LastRow: Integer = -1;
  LastBackgroundCol: TColor;
  LastFontCol: TColor;
  cCOL_PAPERCOLOR: Integer = -1;

procedure TFormPersonSuche.IB_Grid1GetCellProps(Sender: TObject;
  ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
  AFont: TFont);
var
  PAPERCOLOR: string;
begin

  // Im Status "gelb" bitte GAR nix zeichnen oder verändern,
  // sonst wird verhindert dass man den wichtigen geändert sTatus überhuapt
  // als user erkennen und sehen kann!
  if (IB_Query1.State = dssedit) or not(IB_Query1.Active) then
    exit;

  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid1, IB_Query1 do
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

procedure TFormPersonSuche.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  sTreffer := Label1.caption;
  with StringGrid1 do
  begin
    ColCount := 5;
    RowCount := 2;
    DefaultRowHeight := canvas.TextHeight('Xg') + canvas.TextHeight('Xg') div 4;
    ColWidths[0] := 80;
    Cells[0, 0] := 'Nummer';
    ColWidths[1] := 220;
    Cells[1, 0] := 'Name';
    ColWidths[2] := 180;
    Cells[2, 0] := '';
    ColWidths[3] := 180;
    Cells[3, 0] := 'Straße';
    ColWidths[4] := 220;
    Cells[4, 0] := 'Ort';
    Objects[0, 0] := TObject(clWindow);
    Objects[0, 1] := TObject(clWindow);
  end;
  SearchIndex := TWordIndex.create(nil);
  sMitglieder := TgpIntegerList.create;
end;

procedure TFormPersonSuche.FormActivate(Sender: TObject);
var
  UpdateGridSQL: boolean;
begin
  BeginHourGlass;

  if (SearchIndex.LastFileName = '') then
  begin
    UpdateGridSQL := true;
    SearchIndex.LoadFromFile(SearchDir + 'Kunden.Suchindex');
  end
  else
  begin
    UpdateGridSQL := SearchIndex.ReloadIfNew;
  end;

  if UpdateGridSQL then
  begin

    // Grid-Sql prüfen und laden
    if assigned(GridSQL) then
      FreeAndNil(GridSQL);
    if FileExists(iSystemOLAPPath + 'System.Personen.Auswahl' + cOLAPExtension)
    then
    begin
      GridSQL := TSTringList.create;
      GridSQL.LoadFromFile(iSystemOLAPPath + 'System.Personen.Auswahl' +
        cOLAPExtension);
    end;

  end;
  PERSON_R := 0;

  AufgabeRefresh;

  EndHourGlass;
end;

procedure TFormPersonSuche.AufgabeAdd(Gruppe: string; PERSON_R: Integer);
var
  MITGLIEDERLISTE_R: Integer;
  GRUPPE_R: Integer;
  INFO: string;
begin
  if (PERSON_R >= cRID_FirstValid) then
  begin
    // Ist die Person schon in der Liste?
    // -> Einfügen
    GRUPPE_R := AuftragGruppe(Gruppe);
    if (GRUPPE_R < cRID_FirstValid) then
      raise Exception.create('Gruppe nicht angelegt');

    // Setzen des INFO Strings
    if (Edit2.Text = LastValueByScroll) then
      INFO := ''
    else
      INFO := Edit2.Text;

    MITGLIEDERLISTE_R := e_w_gen('GEN_MITGLIEDERLISTE');
    e_x_sql('insert into MITGLIEDERLISTE (RID,BEARBEITER_R,INFO,GRUPPE_R,PERSON_R) values ('
      +
      { } inttostr(MITGLIEDERLISTE_R) + ',' +
      { } inttostr(e_r_Bearbeiter) + ',' +
      { } '''' + INFO + ''',' +
      { } inttostr(GRUPPE_R) + ',' +
      { } inttostr(PERSON_R) + ')');

    AufgabeRefresh;
    IB_Query1.Locate('RID', MITGLIEDERLISTE_R, []);
  end;
end;

procedure TFormPersonSuche.AufgabeAenderungAnzeigen;
begin
  // markiert in der Datenbank die Tatsache, dass
  // an der Mitgliederliste wieder etwas verändert wurde
  // dadurch haben andere Clients dann die Möglichkeit
  // ihre Anzeige entsprechend upzudaten

  GEN_MITGLIEDERLISTE := e_w_gen('GEN_MITGLIEDERLISTE');
  LastRow := -1;

end;

procedure TFormPersonSuche.AufgabeRefresh;
begin
  LastRow := -1;
  GEN_MITGLIEDERLISTE := e_r_gen('GEN_MITGLIEDERLISTE');
  if IB_Query1.Active then
    IB_Query1.Refresh
  else
    IB_Query1.open;
  _TimeRefreshed := frequently;
end;

procedure TFormPersonSuche.AufgabeStatus(Gruppe: string);
var
  GRUPPE_R_ALT: Integer;
  GRUPPE_R_NEU: Integer;
  MITGLIEDERLISTE_R: Integer;
begin
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) then
  begin
    GRUPPE_R_NEU := AuftragGruppe(Gruppe);
    GRUPPE_R_ALT := e_r_sql(
      { } 'select GRUPPE_R from MITGLIEDERLISTE ' +
      { } 'where RID=' + inttostr(MITGLIEDERLISTE_R));

    if (GRUPPE_R_ALT >= cRID_FirstValid) then
      if (GRUPPE_R_ALT <> GRUPPE_R_NEU) then
      begin
        e_x_sql(
          { } 'update MITGLIEDERLISTE set GRUPPE_R=' +
          { } inttostr(GRUPPE_R_NEU) + ',' +
          { } ' SEIT=CURRENT_TIMESTAMP ' +
          { } 'where RID=' +
          { } inttostr(MITGLIEDERLISTE_R));
        AufgabeAenderungAnzeigen;
        AufgabeRefresh;
      end;
  end;
end;

function TFormPersonSuche.AuftragGruppe(Gruppe: string): Integer;
begin
  result := e_r_sql('select RID from GRUPPE where KUERZEL containing ''' +
    Gruppe + '''');
end;

procedure TFormPersonSuche.Button23Click(Sender: TObject);
begin
  ShowMessage('noch keine Funktion!');
end;

procedure TFormPersonSuche.Button2Click(Sender: TObject);
begin
  Nehme;
end;

procedure TFormPersonSuche.Button7Click(Sender: TObject);
var
  MITGLIEDERLISTE_R: Integer;
  qEREIGNIS: TIB_Query;
begin
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) then
  begin

    // Aufgabe als erledigt in das Ereignis sichern!
    qEREIGNIS := nQuery;
    with qEREIGNIS do
    begin
      sql.Add('select');
      sql.Add('RID,ART,INFO,');
      sql.Add('PERSON_R,TICKET_R,BEARBEITER_R,');
      sql.Add('PAPERCOLOR,POSNO,GRUPPE_R,');
      sql.Add('BEENDET from EREIGNIS for update');
      insert;
      FieldByName('RID').AsInteger := cRID_AutoInc;
      FieldByName('ART').AsInteger := eT_AufgabeErledigt;

      // copy Fields
      FieldByName('INFO').assign(IB_Query1.FieldByName('INFO'));
      FieldByName('PERSON_R').assign(IB_Query1.FieldByName('PERSON_R'));
      FieldByName('TICKET_R').assign(IB_Query1.FieldByName('TICKET_R'));
      FieldByName('BEENDET').assign(IB_Query1.FieldByName('SEIT'));
      FieldByName('BEARBEITER_R').assign(IB_Query1.FieldByName('BEARBEITER_R'));
      FieldByName('PAPERCOLOR').assign(IB_Query1.FieldByName('PAPERCOLOR'));
      FieldByName('POSNO').assign(IB_Query1.FieldByName('POSNO'));
      FieldByName('GRUPPE_R').assign(IB_Query1.FieldByName('GRUPPE_R'));
      post;
    end;
    qEREIGNIS.Free;

    // Aufgabe raus
    e_x_sql('delete from MITGLIEDERLISTE where RID=' +
      inttostr(MITGLIEDERLISTE_R));
    AufgabeAenderungAnzeigen;
    AufgabeRefresh;
  end;
end;

procedure TFormPersonSuche.StringGrid1DblClick(Sender: TObject);
begin
  Button2Click(Sender);
end;

procedure TFormPersonSuche.StringGrid1DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with StringGrid1, StringGrid1.canvas do
  begin
    repeat

      if (ARow = 0) then
      begin
        brush.color := FixedColor;
        break;
      end;

      if (ARow = Row) then
      begin
        brush.color := clSkyBlue;
        break;
      end;

      brush.color := clWindow;
    until true;

    if (ARow > -1) then
    begin

      if (ARow < RowCount) and (ARow > 0) then
        if (ACol = 1) or (ACol = 2) then
        begin
          brush.color := TColor(Objects[0, ARow]);
          if (ARow = Row) then
            if brush.color = clWindow then
              brush.color := clSkyBlue;
        end;

      TextRect(Rect, Rect.left + 2, Rect.top + 1, Cells[ACol, ARow]);
    end
    else
    begin
      FillRect(Rect);
    end;
  end;
end;

procedure TFormPersonSuche.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      begin
        Key := #0;
        Nehme;
      end;
    #27:
      begin
        Key := #0;
        Edit1.SetFocus;
      end;
  end;
end;

procedure TFormPersonSuche.Button8Click(Sender: TObject);
begin
  AufgabeAdd('N', Suche_PERSON_R);
end;

procedure TFormPersonSuche.Button9Click(Sender: TObject);
begin
  ShowMessage('noch keine Funktion!');
end;

procedure TFormPersonSuche.Button10Click(Sender: TObject);
begin
  AufgabeStatus('N');
end;

procedure TFormPersonSuche.Button11Click(Sender: TObject);
begin
  if not(DontSetContext) then
    FormPerson.setContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormPersonSuche.Button12Click(Sender: TObject);
var
  PERSON_R: Integer;
  BELEG_R: Integer;
  MITGLIEDERLISTE_R: Integer;
  INFO: string;
begin

  //
  if not(DontSetContext) then
  begin
    PERSON_R := IB_Query1.FieldByName('PERSON_R').AsInteger;
    MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;

    if (PERSON_R = iSchnelleRechnung_PERSON_R) then
    begin
      BELEG_R := strtointdef(nextp(IB_Query1.FieldByName('INFO').AsString,
        '#', 1), 0);
      if (BELEG_R < cRID_FirstValid) then
      begin
        FormBelege.setContext(iSchnelleRechnung_PERSON_R);
        BELEG_R := FormBelege.Neu;

        // Neue Beleg Nummer in den Auftrag eintragen
        INFO := IB_Query1.FieldByName('INFO').AsString + ' #' +
          inttostr(BELEG_R);

        e_x_sql(
          { } 'update MITGLIEDERLISTE set INFO=' +
          { } '''' + INFO + '''' +
          { } 'where RID=' +
          { } inttostr(MITGLIEDERLISTE_R));
        AufgabeAenderungAnzeigen;
      end
      else
      begin
        FormBelege.setContext(iSchnelleRechnung_PERSON_R, BELEG_R);
      end;

    end
    else
    begin
      FormBelege.setContext(PERSON_R);
    end;
  end;
end;

procedure TFormPersonSuche.Button13Click(Sender: TObject);
begin
  NehmeBelege;
end;

procedure TFormPersonSuche.Button14Click(Sender: TObject);
begin
  AufgabeStatus('T');
end;

procedure TFormPersonSuche.Button15Click(Sender: TObject);
begin
  AufgabeAdd('T', Suche_PERSON_R);
end;

procedure TFormPersonSuche.Button16Click(Sender: TObject);
begin
  AufgabeStatus('E');
end;

procedure TFormPersonSuche.Button17Click(Sender: TObject);
begin
  AufgabeAdd('E', Suche_PERSON_R);
end;

procedure TFormPersonSuche.Button18Click(Sender: TObject);
var
  MITGLIEDERLISTE_R: Integer;
  _INFO, INFO: string;
  ROOM: string;
begin
  // Set new prefix
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) then
  begin
    ROOM := (Sender as TButton).caption;

    _INFO := IB_Query1.FieldByName('INFO').AsString;

    if pos(':', _INFO) > 0 then
      INFO := nextp(_INFO, ':', 1)
    else
      INFO := _INFO;

    INFO := cutblank(INFO);

    if (ROOM <> '') then
      INFO := ROOM + ' : ' + INFO;

    if (INFO <> _INFO) then
    begin
      e_x_sql(
        { } 'update MITGLIEDERLISTE set INFO=' +
        { } '''' + INFO + '''' +
        { } 'where RID=' +
        { } inttostr(MITGLIEDERLISTE_R));
      AufgabeAenderungAnzeigen;
      AufgabeRefresh;

    end;

  end;

end;

procedure TFormPersonSuche.Button1Click(Sender: TObject);
begin
  AufgabeAdd('W', Suche_PERSON_R);
end;

procedure TFormPersonSuche.Button3Click(Sender: TObject);
begin
  AufgabeAdd('B', Suche_PERSON_R);
end;

procedure TFormPersonSuche.Button4Click(Sender: TObject);
begin
  AufgabeStatus('W');
end;

procedure TFormPersonSuche.Button5Click(Sender: TObject);
begin
  AufgabeStatus('B');
end;

procedure TFormPersonSuche.Button6Click(Sender: TObject);
begin
  ShowMessage('noch keine Funktion!');
end;

procedure TFormPersonSuche.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      begin
        Key := #0;
        Suche;
      end;
    #27:
      begin
        Key := #0;
        Close;
      end;
  end;
end;

procedure TFormPersonSuche.Edit2DblClick(Sender: TObject);
begin
  Edit2.Text := '';
end;

procedure TFormPersonSuche.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  MITGLIEDER_R: Integer;
begin
  if (Key = #13) then
  begin
    MITGLIEDER_R := IB_Query1.FieldByName('RID').AsInteger;
    if (MITGLIEDER_R >= cRID_FirstValid) then
    begin
      e_x_sql('update MITGLIEDERLISTE set INFO=''' + Edit2.Text +
        ''' where RID=' + inttostr(MITGLIEDER_R));
      Key := #0;
      AufgabeAenderungAnzeigen;
      IB_Query1.Refresh;
      LastValueByScroll := Edit2.Text;
      IB_Grid1.SetFocus;
    end;
  end;
end;

procedure TFormPersonSuche.Suche;
begin
  BeginHourGlass;
  SearchIndex.Search(Edit1.Text);
  Zeige;
  if (SearchIndex.FoundList.Count > 0) then
    StringGrid1.SetFocus
  else
    Edit1.SetFocus;
  EndHourGlass;
end;

function TFormPersonSuche.Suche_PERSON_R: Integer;
begin
  if (StringGrid1.Row >= 1) and (StringGrid1.Row <= SearchIndex.FoundList.Count)
  then
    result := Integer(SearchIndex.FoundList[pred(StringGrid1.Row)])
  else
    result := cRID_unset;
end;

procedure TFormPersonSuche.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;

  if not(visible) then
    exit;

  if IB_Query1.Active then
  begin
    if (GEN_MITGLIEDERLISTE <> e_r_gen('GEN_MITGLIEDERLISTE')) then
      AufgabeRefresh
    else if frequently(_TimeRefreshed, 15000) then
      AufgabeRefresh;
  end;

end;

procedure TFormPersonSuche.Nehme;
begin
  if (StringGrid1.Row >= 1) and (StringGrid1.Row <= SearchIndex.FoundList.Count)
  then
  begin
    PERSON_R := Integer(SearchIndex.FoundList[pred(StringGrid1.Row)]);
    if not(DontSetContext) then
      FormPerson.setContext(PERSON_R)
    else
      Close;
  end
  else
  begin
    Edit1.SetFocus;
  end;
end;

procedure TFormPersonSuche.NehmeBelege;
begin
  if (StringGrid1.Row >= 1) and (StringGrid1.Row <= SearchIndex.FoundList.Count)
  then
  begin
    PERSON_R := Integer(SearchIndex.FoundList[pred(StringGrid1.Row)]);
    if not(DontSetContext) then
      FormBelege.setContext(PERSON_R)
    else
      Close;
  end
  else
  begin
    Edit1.SetFocus;
  end;
end;

procedure TFormPersonSuche.setContext(s: string);
begin
  BeginHourGlass;
  show;
  Edit1.Text := s;
  EndHourGlass;
  Edit1.SetFocus;
end;

procedure TFormPersonSuche.Zeige;
var
  n: Integer;
  cPERSON: TIB_Cursor;
  cANSCHRIFT: TIB_Cursor;
begin
  if (SearchIndex.FoundList.Count > 0) then
  begin

    cPERSON := DataModuleDatenbank.nCursor;
    with cPERSON do
    begin
      if assigned(GridSQL) then
      begin
        sql.AddStrings(GridSQL);
      end
      else
      begin
        sql.Add('SELECT PRIV_ANSCHRIFT_R, NUMMER, VORNAME, NACHNAME, PAPERCOLOR');
        sql.Add('FROM PERSON');
        sql.Add('WHERE RID=:CROSSREF');
      end;
    end;

    cANSCHRIFT := DataModuleDatenbank.nCursor;
    with cANSCHRIFT do
    begin
      sql.Add('SELECT NAME1, STRASSE, LAND_R, STATE, ORT, PLZ');
      sql.Add('FROM ANSCHRIFT');
      sql.Add('WHERE RID=:CROSSREF');
      open;
    end;

    Label1.caption := format(sTreffer, [SearchIndex.FoundList.Count]);
    StringGrid1.RowCount := SearchIndex.FoundList.Count + 1;
    StringGrid1.Row := 1;
    with StringGrid1 do
      for n := 0 to pred(SearchIndex.FoundList.Count) do
      begin
        if (n < 70) or NoLimit then
        begin
          cPERSON.ParamByName('CROSSREF').AsInteger :=
            Integer(SearchIndex.FoundList[n]);
          cPERSON.ApiFirst;
          if cPERSON.Eof then
          begin
            Cells[0, n + 1] := '';
            Cells[1, n + 1] := '';
            Cells[2, n + 1] := '- gelöscht -';
            Cells[3, n + 1] := '';
            Cells[4, n + 1] := '';
            Objects[0, n + 1] :=
              TObject(DataModuleDatenbank.IB_Session1.DeletingColor);
          end
          else
          begin
            cANSCHRIFT.ParamByName('CROSSREF').AsInteger :=
              cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
            cANSCHRIFT.ApiFirst;
            Cells[0, n + 1] := cPERSON.FieldByName('NUMMER').AsString;
            Cells[1, n + 1] := cutblank(cPERSON.FieldByName('VORNAME').AsString
              + ' ' + cPERSON.FieldByName('NACHNAME').AsString);
            Cells[2, n + 1] := cANSCHRIFT.FieldByName('NAME1').AsString;
            Cells[3, n + 1] := cANSCHRIFT.FieldByName('STRASSE').AsString;
            Cells[4, n + 1] := e_r_ort(cANSCHRIFT);
            if cPERSON.FieldByName('PAPERCOLOR').IsNotNull then
              Objects[0, n + 1] :=
                TObject(cPERSON.FieldByName('PAPERCOLOR').AsInteger)
            else
              Objects[0, n + 1] := TObject(clWindow);
          end;
        end
        else
        begin
          Label1.caption := format(sTreffer, [n]) + ' (weitere unterdrückt)';
          Cells[0, n + 1] := '...';
          Cells[1, n + 1] := '';
          Cells[2, n + 1] := '';
          Cells[3, n + 1] := '';
          Cells[4, n + 1] := '';
          Objects[0, n + 1] := TObject(clWindow);
          break;
        end;
      end;

    cPERSON.Free;
    cANSCHRIFT.Free;
  end
  else
  begin
    with StringGrid1 do
    begin
      RowCount := 2;
      Cells[0, 1] := '';
      Cells[1, 1] := '<nicht gefunden>';
      Cells[2, 1] := '';
      Cells[3, 1] := '';
      Cells[4, 1] := '';
      Objects[0, 0] := TObject(clWindow);
      Objects[0, 1] := TObject(clWindow);
    end;
  end;
  NoLimit := false;
end;

procedure TFormPersonSuche.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DontSetContext := false;
end;

procedure TFormPersonSuche.FormDestroy(Sender: TObject);
begin
  FreeAndNil(SearchIndex);
end;

procedure TFormPersonSuche.IB_Grid1GetDisplayText(Sender: TObject;
  ACol, ARow: Integer; var AString: String);
var
  DateA: TANFiXDate;
  SecondsA: TAnfixTime;
  Wartezeit: TAnfixTime;
begin
  if (ARow > 0) then
    if (AString <> '') then
      case ACol of
        // 2, 3: AString := format('%m', [strtodoubledef(AString, 0.0)]);
        1:
          AString := e_r_Person(strtointdef(AString, cRID_NULL));
        2:
          if (AString <> '') then
            AString := '€';
        4:
          begin
            DateA := date2long(nextp(AString, ' ', 0));
            SecondsA := StrToSeconds(nextp(AString, ' ', 1));
            Wartezeit := max(0, SecondsDiff(DateGet, SecondsGet, DateA,
              SecondsA));
            if (Wartezeit < cOneDayInSeconds) then
              AString := secondsToStr5(Wartezeit);
          end;
      end;
end;

procedure TFormPersonSuche.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  LastValueByScroll := IB_Dataset.FieldByName('INFO').AsString;
  Edit2.Text := LastValueByScroll;
end;

procedure TFormPersonSuche.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Personen.Suche');
end;

procedure TFormPersonSuche.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Personen.Aufgaben');
end;

procedure TFormPersonSuche.SpeedButton1Click(Sender: TObject);
var
  ImportL: TSTringList;
  n: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TSTringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);

    SearchIndex.FoundList.clear;
    SearchIndex.FoundList.capacity := pred(ImportL.Count);
    for n := 1 to pred(ImportL.Count) do
      SearchIndex.FoundList.Add
        (pointer(strtointdef(nextp(ImportL[n], ';', 0), -1)));
    ImportL.Free;
    NoLimit := true;
    Zeige;
    if (SearchIndex.FoundList.Count > 0) then
      StringGrid1.SetFocus
    else
      Edit1.SetFocus;
    EndHourGlass;
  end;
end;

procedure TFormPersonSuche.SpeedButton23Click(Sender: TObject);
var
  MITGLIEDERLISTE_R: Integer;
  TICKET_R, PERSON_R: Integer;
  KassenBeleg: TSTringList;
begin
  // gespeicherten Vorgang wiederherstellen!
  // oder einen neuen beginnen!
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) then
  begin
    TICKET_R := IB_Query1.FieldByName('TICKET_R').AsInteger;
    if (TICKET_R < cRID_FirstValid) then
    begin
      PERSON_R := IB_Query1.FieldByName('PERSON_R').AsInteger;

      // new Ticket
      TICKET_R := e_w_gen('GEN_TICKET');
      e_x_sql('insert into TICKET (RID,ART,PERSON_R) values (' +
        { } inttostr(TICKET_R) + ',' +
        { } inttostr(eT_KassenBeleg) + ',' +
        { } inttostr(PERSON_R) + ')');
      e_x_sql(
        { } 'update MITGLIEDERLISTE set TICKET_R=' + inttostr(TICKET_R) +
        { } ' where RID=' +
        { } inttostr(MITGLIEDERLISTE_R));
      AufgabeAenderungAnzeigen;

      // Kassenbeleg aufbereiten
      KassenBeleg := TSTringList.create;
      KassenBeleg.Values['TICKET_R'] := inttostr(TICKET_R);
      KassenBeleg.Values['Titel'] :=
      { } e_r_Person(PERSON_R) + ' ' +
      { } IB_Query1.FieldByName('INFO').AsString;

    end
    else
    begin
      KassenBeleg := e_r_sqlt('select INFO from TICKET where RID=' +
        inttostr(TICKET_R));
      // unterschieben eines neuen TICKET_R verhindern!
      KassenBeleg.Values['TICKET_R'] := inttostr(TICKET_R);
    end;

    // Kasse anwerfen!
    FormBuchBarKasse.setContext(KassenBeleg);
  end;
end;

procedure TFormPersonSuche.SpeedButton27Click(Sender: TObject);
begin
  BeginHourGlass;
  PersonSuchIndex;
  SearchIndex.ReloadIfNew;
  EndHourGlass;
end;

procedure TFormPersonSuche.SpeedButton2Click(Sender: TObject);
var
  Person: TIB_Cursor;
begin
  BeginHourGlass;
  SearchIndex.FoundList.clear;
  Person := DataModuleDatenbank.nCursor;
  with Person do
  begin
    sql.Add('select rid from person where eintrag>=''' +
      long2date(DatePlus(DateGet, -iNeuanlageZeitraum)) + '''');
    sql.Add('order by eintrag descending');
    ApiFirst;
    while not(Eof) do
    begin
      SearchIndex.FoundList.Add(TObject(FieldByName('RID').AsInteger));
      APInext;
    end;
    Close;
  end;
  Person.Free;
  Zeige;
  if (SearchIndex.FoundList.Count > 0) then
    StringGrid1.SetFocus
  else
    Edit1.SetFocus;
  EndHourGlass;
end;

procedure TFormPersonSuche.SpeedButton3Click(Sender: TObject);
var
  Person: TIB_Cursor;
begin
  BeginHourGlass;
  SearchIndex.FoundList.clear;
  Person := DataModuleDatenbank.nCursor;
  with Person do
  begin
    sql.Add('select rid from person where kontaktam>=''' +
      long2date(DatePlus(DateGet, -5)) + '''');
    sql.Add('order by kontaktam descending');
    ApiFirst;
    while not(Eof) do
    begin
      SearchIndex.FoundList.Add(TObject(FieldByName('RID').AsInteger));
      APInext;
    end;
    Close;
  end;
  Person.Free;
  Zeige;
  if (SearchIndex.FoundList.Count > 0) then
    StringGrid1.SetFocus
  else
    Edit1.SetFocus;
  EndHourGlass;

end;

procedure TFormPersonSuche.SpeedButton4Click(Sender: TObject);
begin
  //
  with IB_Query1 do
  begin
    if Active then
      Refresh
    else
      open;
  end;
end;

procedure TFormPersonSuche.SpeedButton5Click(Sender: TObject);
begin
  BeginHourGlass;
  SearchIndex.FoundList.clear;
  SearchIndex.FoundList.Add(pointer(iSchnelleRechnung_PERSON_R));
  Zeige;
  StringGrid1.SetFocus;
  EndHourGlass;
end;

procedure TFormPersonSuche.SpeedButton6Click(Sender: TObject);
var
  MITGLIEDERLISTE_R: Integer;
  qEREIGNIS: TIB_Query;
begin
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) and doit('Wirklich löschen') then
  begin
    // Aufgabe löschen (Ohne Entlassung)
    e_x_sql('delete from MITGLIEDERLISTE where RID=' +
      inttostr(MITGLIEDERLISTE_R));
    AufgabeAenderungAnzeigen;
    AufgabeRefresh;
  end;
end;

procedure TFormPersonSuche.SpeedButton7Click(Sender: TObject);
var
  PERSON_R, PERSON_R_NEU: Integer;
  MITGLIEDERLISTE_R: Integer;
begin
  // Person OBEN
  MITGLIEDERLISTE_R := IB_Query1.FieldByName('RID').AsInteger;
  PERSON_R := IB_Query1.FieldByName('PERSON_R').AsInteger;

  // Person in der Suchtreffer Liste
  if (StringGrid1.Row >= 1) and (StringGrid1.Row <= SearchIndex.FoundList.Count)
  then
    PERSON_R_NEU := Integer(SearchIndex.FoundList[pred(StringGrid1.Row)])
  else
    PERSON_R_NEU := cRID_unset;

  // Aktion an sich
  if (MITGLIEDERLISTE_R >= cRID_FirstValid) and (PERSON_R >= cRID_FirstValid)
    and (PERSON_R_NEU >= cRID_FirstValid) and (PERSON_R <> PERSON_R_NEU) then
  begin
    // Identität soll geändert werden
    if doit(
      { } 'Soll der Eintrag' + #13#10 +
      { } e_r_Person(PERSON_R) + #13#10 +
      { } 'wegfallen? Und ab jetzt' + #13#10 +
      { } e_r_Person(PERSON_R_NEU) + #13#10 + 'eingetragen werden') then
    begin
      // Identität abändern
      e_x_sql(
        { } 'update MITGLIEDERLISTE set PERSON_R=' +
        { } inttostr(PERSON_R_NEU) + ' ' +
        { } 'where RID=' +
        { } inttostr(MITGLIEDERLISTE_R));
      AufgabeAenderungAnzeigen;
      AufgabeRefresh;

      // imp pend: Beleg/Kasse umkopieren
    end;
  end;
end;

end.
