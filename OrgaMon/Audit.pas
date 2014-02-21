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
unit Audit;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons,
  ExtCtrls;

type
  TFormAudit = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    sAudits: TStringList;
  end;

var
  FormAudit: TFormAudit;

implementation

uses
  globals, anfix32, WordIndex,
  IB_Access, IB_Components, Datenbank,
  Funktionen_Auftrag, CareTakerClient, dbOrgaMon,
  wanfix32, AuftragArbeitsplatz;
{$R *.dfm}

type
  TAuditSkeleton = class(TObject)
  protected
    fCSV_Mask: string;
    fCSV_Ergebnis: string;
    fAudit_Cache: string;
    fbreak: boolean;
    sDir: TStringList;
    sCSV: TsTable;
    CSVFName: string;
    sSTATUS: TStringList;
    vStatus: string;

    // Quell-Speicher
    cAUFTRAG: TIB_Cursor;
    AUFTRAG_R: integer;
    wRID: TWordIndex;

    ColIndex_Status, ColIndex_RID, ColIndex_RIDs: integer;
    StartTime: dword;

    constructor Create;
    destructor Destroy; override;
  public

    function fDLAFName: string;
    procedure addStatus(s: string);

    procedure Log(s: string); virtual;
    procedure CheckCSV; virtual;
    procedure setSQL; virtual;
    function Suchbegriff_A(r: integer): string; virtual;
    function Suchbegriff_B(r: integer): string; virtual;
    function IndexBegriff: string; virtual;

    procedure Start;
    procedure DoBreak;

  published
    property Mask: string read fCSV_Mask write fCSV_Mask;
    property Ergebnis: string read fCSV_Ergebnis write fCSV_Ergebnis;
    property Cache: string read fAudit_Cache write fAudit_Cache;
  end;

function TAuditSkeleton.fDLAFName: string;
begin
  result := SearchDir + fAudit_Cache + DatumLog + c_wi_FileExtension;
end;

function TAuditSkeleton.IndexBegriff: string;
begin
  raise Exception.Create('Routine "IndexBegriff" ist nicht implementiert');
end;

procedure TAuditSkeleton.Log(s: string);
begin
  raise Exception.Create('Routine "Log" ist nicht implementiert');
end;

procedure TAuditSkeleton.setSQL;
begin
  raise Exception.Create('Routine "setSQL" ist nicht implementiert');
end;

procedure TAuditSkeleton.CheckCSV;
begin
  raise Exception.Create('Routine "checkCSV" ist nicht implementiert');
end;

procedure TAuditSkeleton.addStatus(s: string);
var
  k: integer;
begin
  //
  k := sSTATUS.IndexOf(s);
  if k <> -1 then
  begin
    sSTATUS.Objects[k] := TObject(integer(sSTATUS.Objects[k]) + 1);
  end
  else
  begin
    sSTATUS.AddObject(s, TObject(1));
  end;
end;

procedure TAuditSkeleton.Start;
var
  n, r: integer;
  SuchBegriff: string;
begin
  BeginHourGlass;

  if Fileexists(fDLAFName) then
  begin
    Log('Lade Cache ' + fDLAFName + ' ... ');
    wRID.LoadFromFile(fDLAFName);
  end
  else
  begin
    Log('Vorlauf ...');
    with cAUFTRAG do
    begin

      setSQL;

      open;
      Log('lade ' + inttostr(REcordCount) + ' Datensätze ...');
      Application.ProcessMessages;
      ApiFirst;
      while not(eof) do
      begin
        AUFTRAG_R := FieldByName('RID').AsInteger;

        SuchBegriff := IndexBegriff;

        if (SuchBegriff <> '') then
          wRID.AddWords(SuchBegriff, TObject(AUFTRAG_R));
        ApiNext;
      end;
      close;
    end;
    cAUFTRAG.Free;
    wRID.JoinDuplicates(false);
    wRID.SaveToFile(fDLAFName);
  end;
  Log(inttostr(wRID.count) + ' Indexeinträge');

  sDir := TStringList.Create;
  dir(AnwenderPath + fCSV_Mask + '*.csv', sDir, false);
  Log('dir ' + AnwenderPath + fCSV_Mask + '*.csv' + ' ...');
  for n := 0 to pred(sDir.count) do
  begin

    CSVFName := sDir[n];
    Log(CSVFName);
    sCSV := TsTable.Create;

    with sCSV do
    begin
      insertFromFile(AnwenderPath + CSVFName);

      CheckCSV;

      ColIndex_Status := addcol('Status');
      ColIndex_RID := addcol('RID');
      ColIndex_RIDs := addcol('RIDs');
      for r := 1 to pred(count) do
      begin

        repeat

          SuchBegriff := Suchbegriff_A(r);

          wRID.Search(SuchBegriff);
          if (wRID.FoundList.count > 0) then
          begin
            AUFTRAG_R := integer(wRID.FoundList[0]);
            wRID.FoundList.Delete(0);
            vStatus := e_r_PhasenStatus(AUFTRAG_R);
            break;
          end;

          SuchBegriff := Suchbegriff_B(r);
          if (SuchBegriff <> '') then
          begin
            wRID.Search(SuchBegriff);
            if (wRID.FoundList.count > 0) then
            begin
              AUFTRAG_R := integer(wRID.FoundList[0]);
              wRID.FoundList.Delete(0);
              vStatus := e_r_PhasenStatus(AUFTRAG_R);
              break;
            end;
          end;

          vStatus := 'unbekannt';
          AUFTRAG_R := cRID_Null;

          // Nun in der Ablage
        until true;

        // über Status berichten
        addStatus(vStatus);
        Log(vStatus);

        // Ergebnis rausschreiben
        writeCell(r, ColIndex_Status, vStatus);
        writeCell(r, ColIndex_RID, inttostr(AUFTRAG_R));
        writeCell(r, ColIndex_RIDs, wRID.FoundList.AsString);

        // im Auftragsarbeitsplatz den Datensatz markieren
        if AUFTRAG_R >= cRID_FirstValid then
          if (FormAuftragArbeitsplatz.ItemsMARKED.IndexOf(pointer(AUFTRAG_R))
            = -1) then
            FormAuftragArbeitsplatz.ItemsMARKED.add(pointer(AUFTRAG_R));

        // Bildschirmausgabe
        if frequently(StartTime, 444) then
        begin
          Application.ProcessMessages;
          if fbreak then
            break;
        end;

      end;
      if fbreak then
        break;
    end;
    ersetzeUpper(fCSV_Mask, fCSV_Ergebnis, CSVFName);
    sCSV.SaveToFile(AnwenderPath + CSVFName);
    sCSV.Free;
  end;

  // Summen
  for n := 0 to pred(sSTATUS.count) do
    Log(sSTATUS[n] + ' ' + inttostr(integer(sSTATUS.Objects[n])));
  EndHourGlass;

end;

function TAuditSkeleton.Suchbegriff_A(r: integer): string;
begin
  result := '';
end;

function TAuditSkeleton.Suchbegriff_B(r: integer): string;
begin
  result := '';
end;

constructor TAuditSkeleton.Create;
begin
  inherited;
  sSTATUS := TStringList.Create;
  wRID := TWordIndex.Create(nil);
  cAUFTRAG := DataModuleDatenbank.nCursor;
end;

destructor TAuditSkeleton.Destroy;
begin
  cAUFTRAG.Free;
  wRID.Free;
  sSTATUS.Free;
  inherited;
end;

procedure TAuditSkeleton.DoBreak;
begin
  fbreak := true;
end;

type
  TAuditDLA = class(TAuditSkeleton)

  protected
    ColIndex_DLA, ColIndex_Position: integer;
    constructor Create;

  public
    procedure Log(s: string); override;
    procedure CheckCSV; override;
    procedure setSQL; override;
    function IndexBegriff: string; override;
    function Suchbegriff_A(r: integer): string; override;
    function Suchbegriff_B(r: integer): string; override;

  end;

function TAuditDLA.Suchbegriff_A(r: integer): string;
begin
  with sCSV do
    if (ColIndex_Position = -1) then
      result := readCell(r, ColIndex_DLA) + '~1'
    else
      result := readCell(r, ColIndex_DLA) + '~' +
        readCell(r, ColIndex_Position);
end;

function TAuditDLA.Suchbegriff_B(r: integer): string;
begin
  with sCSV do
    result := readCell(r, ColIndex_DLA);
end;

procedure TAuditDLA.CheckCSV;
begin
  with sCSV do
  begin
    ColIndex_DLA := colOf('DLA', true);
    ColIndex_Position := colOf('Position');
  end;
end;

constructor TAuditDLA.Create;
begin
  inherited;
  fAudit_Cache := 'RWE-';
  fCSV_Mask := fAudit_Cache + 'OFFEN-';
  fCSV_Ergebnis := fAudit_Cache + 'STATUS-';
end;

function TAuditDLA.IndexBegriff: string;
begin
  with cAUFTRAG do
  begin
    result := FieldByName('SUCHE').AsString;
    ersetze('-', '~', result);
  end;
end;

procedure TAuditDLA.Log(s: string);
begin
  FormAudit.ListBox1.Items.add(s);
  Application.ProcessMessages;
end;

procedure TAuditDLA.setSQL;
begin
  with cAUFTRAG do
  begin
    sql.add('select REGLER_NR as SUCHE,RID from AUFTRAG where');
    sql.add(' (STATUS<>6) and');
    sql.add(' (REGLER_NR is not null) and (REGLER_NR<>'''')');
  end;
end;

type
  TAuditenBW = class(TAuditSkeleton)

  protected
    ColIndex_Auftragsnummer: integer;
    INTERN_INFO: TStringList;

    constructor Create;
  public

    //
    procedure Log(s: string); override;
    procedure CheckCSV; override;
    procedure setSQL; override;
    function IndexBegriff: string; override;
    function Suchbegriff_A(r: integer): string; override;
  end;

procedure TFormAudit.Button1Click(Sender: TObject);
var
  i: integer;
begin
  i := sAudits.IndexOf(ComboBox1.Text);
  if (i <> -1) then
    TAuditSkeleton(sAudits.Objects[i]).Start;
end;

procedure TFormAudit.FormActivate(Sender: TObject);
begin
  if not(assigned(sAudits)) then
  begin
    //
    sAudits := TStringList.Create;

    // mögliche Audits in die Liste aufnehmen
    sAudits.AddObject('RWE-DLA', TAuditDLA.Create);
    sAudits.AddObject('enBW-Auftragsnummer', TAuditenBW.Create);

    //
    ComboBox1.Items.Assign(sAudits);

  end;
end;

procedure TFormAudit.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Audit');
end;

procedure TFormAudit.SpeedButton1Click(Sender: TObject);
begin
  openShell(AnwenderPath);
end;

{ TAuditDLA }

procedure TAuditenBW.CheckCSV;
begin
  with sCSV do
  begin
    ColIndex_Auftragsnummer := colOf('Auftragsnummer', true);
  end;
end;

constructor TAuditenBW.Create;
begin
  inherited;
  fAudit_Cache := 'enBW-';
  fCSV_Mask := fAudit_Cache + 'OFFEN-';
  fCSV_Ergebnis := fAudit_Cache + 'STATUS-';
  INTERN_INFO := TStringList.Create;
end;

function TAuditenBW.IndexBegriff: string;
begin
  with cAUFTRAG do
  begin
    FieldByName('INTERN_INFO').AssignTo(INTERN_INFO);
    result := INTERN_INFO.values['qAuftragsnummer'];
  end;
end;

procedure TAuditenBW.Log(s: string);
begin
  FormAudit.ListBox1.Items.add(s);
  Application.ProcessMessages;
end;

procedure TAuditenBW.setSQL;
begin
  with cAUFTRAG do
  begin
    sql.add('select INTERN_INFO,RID from AUFTRAG where');
    sql.add(' (STATUS<>6) and (BAUSTELLE_R=438)');
  end;
end;

function TAuditenBW.Suchbegriff_A(r: integer): string;
begin
  with sCSV do
    result := readCell(r, ColIndex_Auftragsnummer);
end;

end.
