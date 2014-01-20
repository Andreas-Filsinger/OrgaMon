unit ObermayerImport;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TFormObermayerImport = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormObermayerImport: TFormObermayerImport;

implementation

uses
  anfix32, globals, WordIndex;

{$R *.DFM}

procedure TFormObermayerImport.Button1Click(Sender: TObject);
var
  Titel: TStringList;
  CDs: TSearchStringList;
  CDsOut: TStringList;
  OneLine: string;
  cdNo: integer;
  _cdNo: integer;
  n, m: integer;

  _CD_Titel: string;
  _Track_Titel: string;
  _Track_Komponist: string;
  _Track_Arranger: string;
  _Track_Dirigent: string;
  _Track_Orchester: string;
  _Track_Laufzeit: string;
  TrackLine: string;
  Laufzeiten: string;

  function nextp: string;
  var
    k: integer;
  begin
    k := pos('","', OneLine);
    if (k = 0) then
    begin
      result := copy(OneLine, 2, length(OneLine) - 2);
      OneLine := '';
    end else
    begin
      result := copy(OneLine, 2, k - 2);
      delete(OneLine, 1, k + 1);
    end;
  end;

  procedure CDout;
  var
    FoundIndex: integer;
  begin
    FoundIndex := Cds.FindNear('"' + inttostr(_cdNo) + '"');
    if FoundIndex <> -1 then
      CDsOut.add(Cds[FoundIndex] + ',' +
        '"' + TrackLine + '",' +
        '"' + Laufzeiten + '"')
    else
      CDsOut.add('ERROR:"' + inttostr(_cdNo) + '"');

    TrackLine := '';
    Laufzeiten := '';
  end;

begin
  screen.cursor := crHourGlass;
  Titel := TStringList.create;
  CDs := TSearchStringList.create;
  CDsOut := TStringList.create;
  Titel.LoadFromFile(edit2.Text);
  for n := 0 to pred(Titel.count) do
  begin
    OneLine := Titel[n];
    cdNo := str2int(Nextp);
    Nextp;
    titel[n] := '"' + inttostrN(cdNo, 10) + '",' +
      '"' + inttostrN(n, 10) + '",' +
      OneLine;
  end;
  Titel.sort;
  Titel.SaveToFile(extractFilepath(edit1.Text) + 'Out0.csv');

  CDs.LoadFromFile(edit1.Text);
  for n := 0 to pred(cds.count) do
  begin
    OneLine := Cds[n];

    _CD_Titel := cutblank(nextp);
    cdno := str2int(nextp);

    cds[n] := '"' + inttostr(cdno) + '","' +
      _CD_Titel + '",' +
      OneLine;
  end;
  Cds.Sort;
  Cds.Sorted := true;
  cds.SaveToFile(extractFilepath(edit1.Text) + 'Out1.csv');

  _cdNo := -1;
  TrackLine := '';
  Laufzeiten := '';
  for n := 0 to pred(Titel.count) do
  begin
    OneLine := Titel[n];

  // aktuelle daten einlesen!
    cdNo := str2int(Nextp);

    if (cdNo <> _cdNo) and (_cdNo <> -1) then
      CdOut;

    _cdNo := cdNo;
    nextp; // sub-Tracks überlesen!
    _Track_Titel := cutblank(NextP);
    _Track_Komponist := cutblank(NextP);
    _Track_Arranger := cutblank(NextP);
    _Track_Dirigent := cutblank(NextP);
    _Track_Orchester := cutblank(NextP);
    _Track_Laufzeit := cutblank(NextP);

    TrackLine := TrackLine + _Track_Titel + '|' +
      _Track_Komponist + '|' +
      _Track_Arranger + '|' +
      _Track_Dirigent + '|' +
      _Track_Orchester + '¦';

    Laufzeiten := Laufzeiten + _Track_Laufzeit + '¦';

  end;
  CdOut;

  CdsOut.SaveToFile(extractFilepath(edit1.Text) + 'Out.csv');
  CDsOut.free;
  CDs.free;
  titel.free;

  close;
  screen.cursor := crdefault;
end;

procedure TFormObermayerImport.FormActivate(Sender: TObject);
begin
  edit1.Text := ProgramFilesDir + cCodeName + '\cd_dat1.csv';
  edit2.Text := ProgramFilesDir + cCodeName + '\titel.csv';
end;

end.
