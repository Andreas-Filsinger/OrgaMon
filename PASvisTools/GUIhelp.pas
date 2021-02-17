{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2014  Andreas Filsinger
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
unit GUIhelp;

interface

uses
  SysUtils, Classes, IB_Access,
  IB_Components, IB_Grid, grids;

const
  cMinimalHeaderWidth = 9;

type
  TDataModuleGUIhelp = class(TDataModule)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure HeBuPlaySound(RID: integer);
    procedure HeBuPDF(RID: integer);
  end;

var
  DataModuleGUIhelp: TDataModuleGUIhelp;

procedure HeBuPlaySound(RID: integer);
procedure HeBuPDF(RID: integer);

// Tools für die Speicherung von Spaltenbreiten und Reihenfolge
//
// 1) OnClick bei Speedbutton:
// SaveHeaderSettings(IB_grid, UserDir + HeaderSettingsFName(IB_grid));
// 2) OnMouseDown beim Speedbutton:
(*
  if (Button = mbRight) then
  if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
  begin
  FileDelete(UserDir + HeaderSettingsFName(IB_grid));
  IB_Query.close;
  IB_Query.sql.clear;
  IB_Query.sql.AddStrings(Query_SQL); // <- gerettes Orginal SQL
  IB_Query.open;
  end;
*)
// 3) BeforePrepare bei der Query
// LoadHeaderSettings(IB_grid, UserDir + HeaderSettingsFName(IB_grid));
//
// 4) im FormCreate
// das SQL der Orginal Abfrage reten
//
function HeaderSettingsFName(g: TIB_Grid): string;
procedure SaveHeaderSettings(g: TIB_Grid; FName: string);
procedure LoadHeaderSettings(g: TIB_Grid; FName: string);
function GridSettingsIdentifier(g: TIB_Grid): string;
function HeaderACol(g: TIB_Grid; HeaderFieldName: string): integer;
function HeaderNames(g: TIB_Grid): TStringList;
function ColOfGrid(g: TIB_Grid; FieldName: string): integer; overload;
procedure SecureSetRow(g: TDrawGrid; r: integer);
function FindRid(RID: integer; const s: TStringList): string;

implementation

uses
  dialogs, forms, windows,
  anfix, winamp, WordIndex,
  globals, Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  wanfix;

{$R *.dfm}

procedure HeBuPlaySound(RID: integer);
begin
  DataModuleGUIhelp.HeBuPlaySound(RID);
end;

procedure HeBuPDF(RID: integer);
begin
  DataModuleGUIhelp.HeBuPDF(RID);
end;

procedure TDataModuleGUIhelp.HeBuPDF(RID: integer);
var
  DirEntries: TStringList;
  n: integer;
begin
  DirEntries := e_r_ArtikelPDF(RID);
  if (DirEntries.count > 0) then
  begin
    for n := 0 to pred(DirEntries.count) do
      openShell(DirEntries[n])
  end
  else
    ShowMessage('kein PDF vorhanden!');
  DirEntries.free;
end;

procedure TDataModuleGUIhelp.HeBuPlaySound(RID: integer);
var
  cARTIKEL: TIB_Cursor;
  AllMusikFNames: TStringList;
  SearchMask: string;
  ArtikelNo: string;
  SoundsToPlay: integer;
  n: integer;
begin

  // Artikel
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('SELECT NUMERO FROM ARTIKEL WHERE RID=' + inttostr(RID));
    ApiFirst;
    ArtikelNo := FieldByName('NUMERO').AsString;
  end;
  cARTIKEL.free;

  // Look at all files
  AllMusikFNames := TStringList.create;

  SearchMask := iMusicPath + noblank(ArtikelNo) + '.mp3';
  ersetze('.mp3', '*.mp3', SearchMask);
  dir(SearchMask, AllMusikFNames, false);
  SoundsToPlay := AllMusikFNames.count;
  if (SoundsToPlay > 0) then
  begin
    if not(WinAmpRunning) then
      WinAmpLoadUp;

    BeginHourGlass;
    WinAmpClearPlayList;
    AllMusikFNames.sort;
    for n := 0 to pred(AllMusikFNames.count) do
      WinAmpAddOneFile(iMusicPath + AllMusikFNames[n]);
    WinAmpShow;
    WinAmpPlay;
    sleep(500);
    application.processmessages;
    EndHourGlass;
  end
  else
  begin
    // nix gefunden!
    ShowMessage(SearchMask + ' nicht gefunden!');
  end;
  AllMusikFNames.free;
end;

function HeaderACol(g: TIB_Grid; HeaderFieldName: string): integer;
var
  n: integer;
begin
  result := -1;
  with g do
    for n := 0 to pred(GridFieldCount) do
      if (GridFields[n].FieldName = HeaderFieldName) then
      begin
        result := succ(n);
        break;
      end;
end;

procedure SaveHeaderSettings(g: TIB_Grid; FName: string);
var
  k, n: integer;
  oColsL: TSearchStringList;
  nColsL: TStringList;
begin
  // Reihenfolge + Breite abspeichern!
  // ganze kleine Spalten ganz unten!
  oColsL := TSearchStringList.create;
  nColsL := TStringList.create;
  with g do
    for n := 0 to pred(GridFieldCount) do
    begin
      nColsL.add(GridFields[n].FieldName + '=' +
        inttostr(GridFields[n].DisplayWidth));
      k := oColsL.findinc(GridFields[n].FieldName + '=');
      if (k <> -1) then
        oColsL.delete(k)
    end;
  nColsL.addStrings(oColsL);
  nColsL.SaveToFile(FName);
  nColsL.free;
  oColsL.free;

  // Neue Settings aktivieren
  if g.datasource.dataset.active then
  begin
    g.datasource.dataset.close;
    LoadHeaderSettings(g, FName);
    g.datasource.dataset.open;
  end;
end;

procedure LoadHeaderSettings(g: TIB_Grid; FName: string);
var
  ColsL: TStringList;
  k, m, n: integer;
  TheWidth: integer;
  nSQL: TStringList; // new SQL
  oSQL: TStringList; // old SQL
  sSQL: TStringList; // sorted SQL
  AutomataState: integer;
  BeginFields: integer;
  FieldName: string;

  function SearchFor(s: string): integer;
  var
    n, k, l: integer;
  begin
    result := -1;
    l := length(s);
    for n := 0 to pred(oSQL.count) do
    begin
      k := revpos(s, oSQL[n]);
      if (k > 0) and (k = succ(length(oSQL[n]) - l)) then
      begin

        // Prüfen, ob der Bezeichner nicht nach links noch weitergeht?!
        if (k > 1) then
          if CharInSet(oSQL[n][pred(k)], ['A' .. 'Z', '0' .. '9', '_']) then
            continue;
        result := n;
        break;
      end;
    end;
  end;

begin
  if FileExists(ExtractFilePath(FName) + '..\' + ExtractFileName(FName)) then
    FName := ExtractFilePath(FName) + '..\' + ExtractFileName(FName);
  if FileExists(FName) then
  begin
    if g.datasource.dataset.active then
      g.datasource.dataset.close;

    ColsL := TStringList.create;
    ColsL.LoadFromFile(FName);
    nSQL := TStringList.create;
    oSQL := TStringList.create;
    sSQL := TStringList.create;

    // Spaltenreihenfolge anpassen
    AutomataState := 0;
    nSQL.addStrings(g.datasource.dataset.sql);

    for n := 0 to pred(nSQL.count) do
    begin
      case AutomataState of
        0:
          begin // search "SELECT"
            if pos('SELECT', nSQL[n]) = 1 then
            begin
              BeginFields := succ(n);
              AutomataState := 1;
            end;
          end;
        1:
          begin
            if pos('FROM', nSQL[n]) = 1 then
            begin
              // processing
              for m := 0 to pred(ColsL.count) do
              begin
                FieldName := nextp(ColsL[m], '=', 0);

                // Methode "1", Feld Alias mit
                repeat
                  k := SearchFor('as ' + FieldName);
                  if (k <> -1) then
                    break;
                  k := SearchFor(' ' + FieldName);
                  if (k <> -1) then
                    break;
                  k := SearchFor('.' + FieldName);
                  if (k <> -1) then
                    break;
                  k := SearchFor(FieldName);
                  if (k <> -1) then
                    break;
                until yet;

                if (k <> -1) then
                begin
                  sSQL.add(oSQL[k]);
                  oSQL.delete(k);
                end;
              end;

              // Rest, was nich berührt war hinten dran
              sSQL.addStrings(oSQL);

              // Sicherstellen, dass die Kommas stimmen
              if pos(',', sSQL[0]) = 1 then
                sSQL[0] := copy(sSQL[0], 2, MaxInt);
              for m := 1 to pred(sSQL.count) do
                if pos(',', sSQL[m]) <> 1 then
                  sSQL[m] := ',' + sSQL[m];

              // Nun die bisherige Felderreihenfolge Überschreiben!
              for m := 0 to pred(sSQL.count) do
                g.datasource.dataset.sql[BeginFields + m] := sSQL[m];

              break;
              AutomataState := 2;
            end
            else
            begin
              oSQL.add(nSQL[n]);
            end;
          end;
      end;
    end;

    // nun Spaltenbreiten anpassen
    for n := 0 to pred(ColsL.count) do
    begin
      FieldName := nextp(ColsL[n], '=', 0);
      TheWidth := strtointdef(nextp(ColsL[n], '=', 1), 0);
      if (TheWidth >= cMinimalHeaderWidth) then
      begin
        g.datasource.dataset.FieldsDisplayWidth.values[FieldName] :=
          inttostr(TheWidth);
        g.datasource.dataset.Fieldsvisible.values[FieldName] := 'TRUE';
      end
      else
      begin
        g.datasource.dataset.Fieldsvisible.values[FieldName] := 'FALSE';
      end;
    end;
    ColsL.free;
    nSQL.free;
    oSQL.free;
    sSQL.free;
  end;

end;

function GridSettingsIdentifier(g: TIB_Grid): string;
begin
  with g do
    result :=
    // Formular
      datasource.dataset.owner.name + '.' +
    // Grid
      name + '.' +
    // Query / Cursor
      datasource.dataset.name;
end;

function HeaderSettingsFName(g: TIB_Grid): string;
begin
  result := 'Spalteneinstellung.' + GridSettingsIdentifier(g) + '.txt';
end;

function HeaderNames(g: TIB_Grid): TStringList;
var
  n: integer;
begin
  result := TStringList.create;
  with g do
    for n := 0 to pred(GridFieldCount) do
      result.add(GridFields[n].FieldName);
end;

function ColOfGrid(g: TIB_Grid; FieldName: string): integer;
var
  sHeaderNames: TStringList;
begin
  sHeaderNames := HeaderNames(g);
  result := sHeaderNames.IndexOf(FieldName);
  if (result <> -1) then
    inc(result);
  sHeaderNames.free;
end;

procedure SecureSetRow(g: TDrawGrid; r: integer);
begin
  with g do
  begin
    SetFocus;
    Row := r;
    // Alle Zeichenoperationen müssen abgeschlossen sein
    application.processmessages;
    if (r = 0) then
    begin
      keybd_event(VK_DOWN, 0, 0, 0);
      keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
      keybd_event(VK_UP, 0, 0, 0);
      keybd_event(VK_UP, 0, KEYEVENTF_KEYUP, 0);
    end
    else
    begin
      keybd_event(VK_UP, 0, 0, 0);
      keybd_event(VK_UP, 0, KEYEVENTF_KEYUP, 0);
      keybd_event(VK_DOWN, 0, 0, 0);
      keybd_event(VK_DOWN, 0, KEYEVENTF_KEYUP, 0);
    end;
    // Auch folgende Aktionen sollten mit einer abgearbeiteten
    // Aufgabenliste starten
    application.processmessages;
  end;
end;

function FindRid(RID: integer; const s: TStringList): string;
var
  n: integer;
begin
  for n := 0 to pred(s.count) do
    if RID = integer(s.objects[n]) then
    begin
      result := s[n];
      exit;
    end;
  result := cRefComboOhneEintrag;
end;

end.
