//
// todo -
//   alle Worte "VERLAGE" durch MARKEN ersetzten
//   nochmals trennen zwischen LIEFERANT und MARKE/HERSTELLER
//
unit Verlag;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, HebuData,
  IB_Components, Grids, StdCtrls,
  ComCtrls, IB_Grid;

type
  TFormVerlag = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button8: TButton;
    Edit1: TEdit;
    Button7: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    DrawGrid1: TDrawGrid;
    Button1: TButton;
    Button2: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    Button6: TButton;
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    IB_DSQL1: TIB_DSQL;
    IB_DSQL3: TIB_DSQL;
    IB_Query8: TIB_Query;
    ProgressBar1: TProgressBar;
    Button5: TButton;
    Label18: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button2Click(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    VerlagRID: TList;
    VerlageBaseRID: TList;
    _AllVerlage: TStringList; // via PERSON_R (unique), start by ensurecache
    _AllVerlage2: TStringList; // via RID (unique), start by ensurecache
    _AllVerlageRID: TStringList; //

    SubCache: TStringList;
    SubCacheRID: integer;

    procedure RefreshCData;
  public
    { Public-Deklarationen }
    CalcLagerLog: TStringList;

    function ObtainVerlagFromPERSON_RID(RID: integer): string;
    function ObtainVerlag_RIDFromPERSON_RID(RID: integer): integer;
    function ObtainPERSON_RIDFromVerlag(Verlag: string): integer;
    function ObtainVerlag_Alias(VERLAG_R: integer): integer;
    procedure ClearVerlagRID;
    function AllVerlage: TStringList; // NICHT FREIGEBEN
    procedure ReflectListe;
    function Subs(RID: integer): TStringList;

    //
    procedure EnsureCache;
    procedure DisableCache;
    function ObtainVerlagFromRID(RID: integer): string;
    function ObtainRIDfromVerlag(s: string): integer;
    function AlleVerlage: TStringList;

    // Lager - Tools
    procedure EnsureSystemLager;
  end;

var
  FormVerlag: TFormVerlag;

implementation

uses
  anfix32, globals, Person,
  Lager, Sortiment, PreisCode,
  eCommerce, gplists;

{$R *.DFM}

const
  c_Field_verlag_Name = 0;
  c_Field_verlag_Artikel = 1;
  c_Field_verlag_Menge = 2;
  c_Field_verlag_PERSON_RID = 3;
  c_Field_verlag_Volumen = 4;
  c_Field_verlag_Lager = 5;
  c_Field_verlag_Bedarf = 6;
  c_Field_verlag_Lager_ist = 7;
  c_Field_verlag_RID = 8;
  c_Field_verlag_Lager_used = 9;

  c_Field_verlag_count = 10;

procedure TFormVerlag.Button1Click(Sender: TObject);
var
  lVERLAG: TIntegerList;
  VERLAG_R: integer;
  n: integer;
begin
  if doit('Verlage ohne Personenzuordnung löschen') then
  begin
    lVERLAG := DataModuleeCommerce.e_r_sqlm('select rid from verlag where PERSON_R is null');
    for n := 0 to pred(lVERLAG.count) do
    begin
      VERLAG_R := lVERLAG[n];
beforedelete
      DataModuleeCommerce.e_x_sql('delete from VERLAG where RID=' + inttostr(VERLAG_R));
    end;
    lVERLAG.free;
  end;
  RefreshCData;
end;

procedure TFormVerlag.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;

  button8.caption := cVerlagUebergangsfach + ' && ' +
    cVerlagFreiesLager + ' erstellen';

  VerlagRID := TList.create;
  VerlageBaseRID := TList.create;
  SubCache := TStringList.create;
  CalcLagerLog := TStringList.create;

  SubCacheRID := -1;
  _AllVerlageRID := TStringList.create;
  with DrawGrid1, canvas do
  begin
    rowCount := 0;
    DefaultRowHeight := 30;
    Font.Name := 'Verdana';
    Font.Size := 8;
    Font.Color := clblack;
    ColCount := 7;
    ColWidths[0] := 300;
    ColWidths[1] := 40;
    ColWidths[2] := 40;
    ColWidths[3] := 40;
    ColWidths[4] := 40;
    ColWidths[5] := 40;
    ColWidths[6] := 400;
    ClientHeight := succ(ClientHeight div DefaultRowHeight) * DefaultRowHeight;
  end;
end;

procedure TFormVerlag.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SubItems: TStringList;
  _ACol: integer;
  _TextWidth: integer;
  OrgBrush: TColor;
  DontCheckLast: boolean;
  VERLAG_R: integer;
begin
  if arow >= 0 then
    with DrawGrid1.canvas do
    begin

      if odd(ARow) then
      begin
        brush.color := clWhite;
      end else
      begin
        brush.color := clListeGrau;
      end;

      if (ARow = DrawGrid1.Row) then
        brush.color := $0080FFFF;

      if (ARow < VerlageBaseRID.count) then
      begin
        VERLAG_R := integer(VerlageBaseRID[ARow]);
        SubItems := Subs(integer(VerlageBaseRID[ARow]));
        case ACol of
          0: begin
              if (VERLAG_R = DataModuleeCommerce.e_r_Uebergangsfach_VERLAG_R) or
                (VERLAG_R = DataModuleeCommerce.e_r_FreiesLager_VERLAG_R) then
                brush.color := clred;

              TextRect(rect, rect.left + 2, rect.top + 8, SubItems[c_Field_verlag_Name] + ' [' +
                inttostr(VERLAG_R) + ']');
            end;
          1: begin
              TextRect(rect, rect.left + 2, rect.top, SubItems[c_Field_verlag_Artikel]);
            end;
          2: begin
              TextRect(rect, rect.left + 2, rect.top, SubItems[c_Field_verlag_Menge]);
            end;
          3: begin
              TextRect(rect, rect.left + 2, rect.top, SubItems[c_Field_verlag_Volumen]);
            end;
          4: begin
              TextRect(rect, rect.left + 2, rect.top, SubItems[c_Field_verlag_Bedarf]);
              TextOut(rect.left + 2, rect.top + ryl(rect) div 2, SubItems[c_Field_verlag_Lager_used]);
            end;
          5: begin
              TextRect(rect, rect.left + 2, rect.top, SubItems[c_Field_verlag_Lager_ist]);
            end;
        else
          FillRect(rect);
        end;

        if (ACol > 0) then
        begin
          pen.color := $A0A0A0;
          MoveTo(rect.left, rect.top);
          LineTo(rect.left, pred(rect.bottom));
          LineTo(rect.right, pred(rect.bottom));
        end else
        begin
          pen.color := $A0A0A0;
          MoveTo(rect.left, pred(rect.bottom));
          LineTo(rect.right, pred(rect.bottom));
        end;

      end else
      begin
        FillRect(rect);
      end;
    end;

end;

procedure TFormVerlag.ClearVerlagRID;
var
  n: integer;
begin
 //
  _AllVerlageRID.clear;
  for n := 0 to pred(VerlagRID.count) do
    TStringList(VErlagRID[n]).free;
  VerlagRID.clear;
end;

procedure TFormVerlag.Button2Click(Sender: TObject);
var
  Sub: TStringList;
begin
  if (VerlageBaseRID.count > 0) then
  begin
    Sub := Subs(integer(VerlageBaseRID[DrawGrid1.row]));
    if assigned(Sub) then
      FormPerson.SetContext(strtoint(Sub[c_Field_verlag_PERSON_RID]));
  end;
end;

procedure TFormVerlag.DrawGrid1DblClick(Sender: TObject);
begin
  Button2Click(Sender);
end;

function TFormVerlag.AllVerlage: TStringList;
begin
  EnsureCache;
  result := _AllVerlage;
end;

function TFormVerlag.ObtainPERSON_RIDFromVerlag(Verlag: string): integer;
var
  k: integer;
begin
  EnsureCache;
  k := AllVerlage.indexof(Verlag);
  if (k = -1) then
    result := -1
  else
    result := integer(_AllVerlage.objects[k]);
end;

function TFormVerlag.ObtainVerlagFromPERSON_RID(RID: integer): string;
var
  n: integer;
begin
  EnsureCache;
  for n := 0 to pred(_AllVerlage.count) do
    if RID = integer(_AllVerlage.objects[n]) then
    begin
      result := _AllVerlage[n];
      exit;
    end;
  result := '';
end;

procedure TFormVerlag.FormActivate(Sender: TObject);
begin
  SubCacheRID := -1;
  if VerlageBaseRID.count = 0 then
  begin
    RefreshCData;
    ReflectListe;
  end else
  begin
    DrawGrid1.refresh;
  end;
  DrawGrid1.SetFocus;
end;

procedure TFormVerlag.ReflectListe;
var
  ClientSorter: TStringlist;
  n: integer;
begin

  //
  with IB_query4 do
  begin
    Open;
    VerlageBaseRID.clear;
    VerlageBaseRID.Capacity := RecordCount;
    first;
    while not (eof) do
    begin
      VerlageBaseRID.add(pointer(FieldByName('RID').AsInteger));
      next;
    end;
    Close;
  end;
  label5.caption := inttostr(VerlageBaseRID.count);

  // Sortieren
  SubCacheRID := -1;
  ClientSorter := TStringlist.create;
  for n := 0 to pred(VerlageBaseRID.count) do
    ClientSorter.addobject(AnsiUpperCase(Subs(integer(VerlageBaseRID[n]))[c_Field_verlag_Name]), VerlageBaseRID[n]);
  ClientSorter.sort;
  for n := 0 to pred(VerlageBaseRID.count) do
    VerlageBaseRID[n] := ClientSorter.objects[n];
  ClientSorter.free;

  // Liste neu anzeigen
  PageControl1.ActivePage := TabSheet1;
  DrawGrid1.RowCount := VerlageBaseRID.count;
  SubCacheRID := -1;
  DrawGrid1.refresh;
  DrawGrid1.SetFocus;

end;

function TFormVerlag.Subs(RID: integer): TStringList;
var
  n: integer;
  Subs: TStringList;
  PERSON_R: integer;
begin
  if (RID <> SubCacheRID) then
  begin
  //
    SubCache.clear;
    for n := 0 to pred(c_Field_verlag_count) do
      SubCache.add('');

    with IB_Query3 do
    begin
      ParamByName('CROSSREF').AsInteger := RID;
      if not (active) then
        Open;
      if not (IsEmpty) then
      begin
        PERSON_R := FieldByName('PERSON_R').AsInteger;

        with IB_Query1 do
        begin
          ParamByName('CROSSREF').AsInteger := PERSON_R;
          if not (active) then
            Open;
          if not (IsEmpty) then
            SubCache[c_Field_verlag_Name] := FieldByName('SUCHBEGRIFF').AsString;
        end;

        Subs := nil;
        n := _AllVerlageRID.indexof(inttostr(PERSON_R));
        if (n <> -1) then
          Subs := TStringList(_AllVerlageRID.objects[n]);
        if assigned(Subs) then
        begin
          // zusätzliche Calculierte Infos
          with Subs do
          begin
            SubCache[c_Field_verlag_Artikel] := strings[c_Field_verlag_Artikel];
            SubCache[c_Field_verlag_Menge] := strings[c_Field_verlag_Menge];
            SubCache[c_Field_verlag_Bedarf] := strings[c_Field_verlag_Bedarf];
            SubCache[c_Field_verlag_Lager_ist] := strings[c_Field_verlag_Lager_ist];
            SubCache[c_Field_verlag_Lager_used] := strings[c_Field_verlag_Lager_used];
          end;
        end;
        SubCache[c_Field_verlag_Volumen] := FieldByName('VOLUMEN').AsString;
        SubCache[c_Field_verlag_Lager] := '';
        SubCache[c_Field_verlag_PERSON_RID] := inttostr(PERSON_R);
        SubCache[c_Field_verlag_RID] := inttostr(RID);
      end;
    end;
    SubCacheRID := RID;
  end;
  result := SubCache;
end;

procedure TFormVerlag.EnsureCache;
var
  PERSON_R: integer;
  VERLAG_R: integer;
  VerlagName: string;
  cVERLAG: TIB_Cursor;
begin
  if not (assigned(_AllVerlage2)) then
  begin
    BeginHourGlass;
    _AllVerlage := TStringList.create;
    _AllVerlage2 := TStringList.create;

    cVERLAG := TIB_Cursor.create(self);
    with cVERLAG do
    begin
      sql.add('SELECT * FROM VERLAG');
      ApiFirst;

      while not (eof) do
      begin
        VERLAG_R := FieldByName('RID').AsInteger;
        PERSON_R := FieldByName('PERSON_R').AsInteger;
        with IB_Query1 do
        begin
          ParamByName('CROSSREF').AsInteger := PERSON_R;
          if not (active) then
            Open;
          if not (IsEmpty) then
          begin
            VerlagName := FieldByName('SUCHBEGRIFF').AsString;
            if (VerlagName <> '') then
              _AllVerlage2.AddObject(VerlagName, pointer(VERLAG_R))
            else
              _AllVerlage2.AddObject(inttostrN(VERLAG_R, 6), pointer(VERLAG_R));

            _AllVerlage.addobject(VerlagName, pointer(PERSON_R));
          end else
          begin
            _AllVerlage2.AddObject('link broken', pointer(VERLAG_R));
          end;
        end;
        ApiNext;
      end;
    end;
    cVERLAG.free;
    _AllVerlage2.sort;
    _AllVerlage.sort;
    removeDuplicates(_AllVerlage);
    EndHourGlass;
  end;
end;

procedure TFormVerlag.DisableCache;
begin
  FreeAndNil(_AllVerlage2);
  FreeAndNil(_AllVerlage);
end;

procedure TFormVerlag.FormDeactivate(Sender: TObject);
begin
  DisableCache;
end;

function TFormVerlag.ObtainVerlagFromRID(RID: integer): string;
var
  n: integer;
begin
  EnsureCache;
  for n := 0 to pred(_AllVerlage2.count) do
    if RID = integer(_AllVerlage2.objects[n]) then
    begin
      result := _AllVErlage2[n];
      exit;
    end;
  result := '';
end;

function TFormVerlag.ObtainRIDfromVerlag(s: string): integer;
var
  n, k: integer;
begin
  EnsureCache;
  k := _AllVerlage2.indexof(s);
  if k <> -1 then
    k := integer(_AllVerlage2.objects[k]);
  result := k;
end;

function TFormVerlag.AlleVerlage: TStringList;
begin
  EnsureCache;
  result := _AllVerlage2;
end;

procedure TFormVerlag.Button5Click(Sender: TObject);
var
  Sub: TStringList;
begin
  if (VerlageBaseRID.count > 0) then
  begin
    Sub := Subs(integer(VerlageBaseRID[DrawGrid1.row]));
    if assigned(Sub) then
      FormLager.CreateNew(strtoint(Sub[c_Field_verlag_RID]),
        strtol(Sub[c_Field_verlag_Bedarf]) - strtol(Sub[c_Field_verlag_Lager_ist])
        );
  end;
end;


procedure TFormVerlag.Button6Click(Sender: TObject);
begin
  FormPreisCode.show;
end;

function TFormVerlag.ObtainVerlag_RIDFromPERSON_RID(RID: integer): integer;
var
  VERLAG: TIB_Cursor;
begin
  VERLAG := TIB_Cursor.create(self);
  with VERLAG do
  begin
    sql.add('select RID from VERLAG where PERSON_R=' + inttostr(RID));
    first;
    if eof then
      result := -1
    else
      result := FieldByName('RID').AsInteger;
  end;
  VERLAG.free;
end;

procedure TFormVerlag.Button7Click(Sender: TObject);
var
  _date: TANFixDate;
  _verlag_R: integer;
  Sub: TStringList;
begin
  _date := date2long(edit1.text);

  if (VerlageBaseRID.count > 0) then
  begin
    Sub := Subs(integer(VerlageBaseRID[DrawGrid1.row]));
    if assigned(Sub) then
    begin
      _Verlag_R := strtoint(Sub[c_Field_verlag_PERSON_RID]);
    end;
  end;

  with IB_Query8 do
  begin
    parambyName('CROSSREF').AsInteger := _Verlag_R;
    open;
    if doit(inttostr(RecordCount) + ' Datums ohne Eintrag!' + #13 +
      'jetzt anpassen') then
    begin
      BeginHourGlass;
      while not (eof) do
      begin
        edit;
        FieldByName('VERLAG_STAT_START').AsDate := long2datetime(_date);
        update;
        next;
      end;
      EndHourGlass;
    end;
    close;
  end;
end;

function TFormVerlag.ObtainVerlag_Alias(VERLAG_R: integer): integer;
var
  ALIAS: TIB_Cursor;
  Visited_Verlag_R: TStringList;
begin
  ALIAS := TIB_Cursor.create(self);
  with ALIAS do
  begin
    Visited_Verlag_R := TStringList.create;
    repeat
      sql.clear;
      sql.add('SELECT ALIAS_R FROM PREIS WHERE (VERLAG_R=' +
        inttostr(VERLAG_R) +
        ') AND (ALIAS_R IS NOT NULL)');
      first;
      if eof then
        break;
      Visited_Verlag_R.add(inttostr(VERLAG_R));
      VERLAG_R := FieldByName('ALIAS_R').AsInteger;
      if (Visited_Verlag_R.indexof(inttostr(VERLAG_R)) <> -1) then
      begin
       // imp pend
       // alias loop detected
        break;
      end;
    until false;
    close;
    Visited_Verlag_R.free;
  end;
  ALIAS.free;
  result := VERLAG_R;
end;

procedure TFormVerlag.RefreshCData;
var
  VERLAG_R: integer;
  PERSON_R: integer;
  MENGE: integer;

  StartTime: dword;
  RecN: integer;
  n: integer;

  s_Field_verlag_Artikel: integer;
  s_Field_verlag_Menge: integer;
  s_Field_verlag_Volumen: integer;
  s_Field_verlag_Bedarf: integer;
  s_Field_verlag_Ist: integer;
  s_Field_verlag_Lager_used: integer;
  Sub: TStringList;

  cVERLAG: TIB_Cursor;
  qVERLAG: TIB_Query;
begin
  BeginHourGlass;
  with IB_Query2 do
  begin

    _AllVerlageRID.clear;

    ClearVerlagRID;
    StartTime := 0;
    RecN := 0;
    if not (active) then
      Open
    else
      refresh;
    progressbar1.max := RecordCount;
    VERLAG_R := -1;
    first;
    while not (eof) do
    begin

      if (FieldByName('VERLAG_R').AsInteger = VERLAG_R) then
      begin
        Sub[c_Field_verlag_Artikel] := inttostr(strtoint(Sub[c_Field_verlag_Artikel]) + 1);
        MENGE := FieldByName('MENGE').AsInteger;
        if (MENGE > 0) or (FieldByName('MINDESTBESTAND').AsInteger > 0) then
        begin
          Sub[c_Field_verlag_Menge] := inttostr(strtol(Sub[c_Field_verlag_Menge]) + MENGE);
          Sub[c_Field_verlag_Bedarf] := inttostr(strtol(Sub[c_Field_verlag_Bedarf]) + 1);
        end;
      end else
      begin
        VERLAG_R := FieldByName('VERLAG_R').AsInteger;
        Sub := TStringList.create;
        VerlagRID.add(Sub);
        Sub.capacity := c_Field_verlag_count;
        for n := 0 to pred(c_Field_verlag_count) do
          Sub.add('');

        // sub füllen
        Sub[c_Field_verlag_Name] := ObtainVerlagFromPERSON_RID(VERLAG_R);
        Sub[c_Field_verlag_Artikel] := '1';
        MENGE := FieldByName('MENGE').AsInteger;
        if (MENGE > 0) then
          Sub[c_Field_verlag_Bedarf] := '1'
        else
          Sub[c_Field_verlag_Bedarf] := '0';
        Sub[c_Field_verlag_Menge] := inttostr(MENGE);
        Sub[c_Field_verlag_PERSON_RID] := inttostr(VERLAG_R);

        _AllVerlageRID.addobject(Sub[c_Field_verlag_PERSON_RID], Sub);
      end;

      next;
      inc(RecN);
      if frequently(StartTime, 333) or eof then
      begin
        application.processmessages;
        progressbar1.position := RecN;
      end;
    end;
  end;
  progressbar1.position := 0;
  label4.caption := '(' + inttostr(VerlagRID.count) + 'x)';


  cVERLAG := TIB_Cursor.create(self);
  with cVERLAG do
  begin
    sql.add('select RID from VERLAG where PERSON_R=:CROSSREF');
    prepare;
    progressbar1.max := VerlagRID.count;
    for n := 0 to pred(VerlagRID.count) do
    begin
      PERSON_R := strtoint(TStringList(VerlagRID[n])[c_Field_verlag_PERSON_RID]);

      // ev. neu anlegen?
      ParamByName('CROSSREF').AsInteger := PERSON_R;
      ApiFirst;
      if eof then
      begin

        qVERLAG := TIB_Query.create(self);
        with qVERLAG do
        begin
          sql.add('select * from VERLAG for update');
          append;
          FieldByName('RID').AsInteger := 0;
          FieldByName('PERSON_R').AsInteger := PERSON_R;
          post;
        end;
        qVERLAG.free;

        TStringList(VerlagRID[n])[c_Field_verlag_Lager_ist] := '00'; // marker für Neuanlage

      end else
      begin
        VERLAG_R := FieldByName('RID').AsInteger;

        // Anzahl der Lagerplätze ermitteln
        with IB_DSQL1 do
        begin
          ParamByName('CROSSREF').AsInteger := VERLAG_R;
          execute;
          TStringList(VerlagRID[n])[c_Field_verlag_Lager_ist] := FieldByName('RID').AsString;
        end;

        // Anzahl der Artikel mit Lagerplatz ermitteln
        with IB_DSQL3 do
        begin
          ParamByName('CROSSREF').AsInteger := PERSON_R;
          execute;
          TStringList(VerlagRID[n])[c_Field_verlag_Lager_used] := FieldByName('RID').AsString;
        end;

      end;

      progressbar1.position := n;
      application.processmessages;
    end;
    close;
  end;
  cVERLAG.free;

 //
  _AllVerlageRID.sort;
  ReflectListe;
  progressbar1.position := 0;


  s_Field_verlag_Artikel := 0;
  s_Field_verlag_Menge := 0;
  s_Field_verlag_Volumen := 0;
  s_Field_verlag_Bedarf := 0;
  s_Field_verlag_Ist := 0;
  s_Field_verlag_Lager_used := 0;
  for n := 0 to pred(VerlageBaseRID.count) do
  begin
    Sub := subs(integer(VerlageBaseRID[n]));
    inc(s_Field_verlag_Artikel, strtol(Sub[c_Field_verlag_Artikel]));
    inc(s_Field_verlag_Menge, strtol(Sub[c_Field_verlag_Menge]));
    inc(s_Field_verlag_Volumen, strtol(Sub[c_Field_verlag_Volumen]));
    inc(s_Field_verlag_Bedarf, strtol(Sub[c_Field_verlag_Bedarf]));
    inc(s_Field_verlag_Ist, strtol(Sub[c_Field_verlag_Lager_ist]));
    inc(s_Field_verlag_Lager_used, strtol(Sub[c_Field_verlag_Lager_used]));
  end;
  StaticText1.Caption := inttostr(s_Field_verlag_Artikel);
  StaticText2.Caption := inttostr(s_Field_verlag_Menge);
  StaticText3.Caption := inttostr(s_Field_verlag_Volumen);
  StaticText4.Caption := inttostr(s_Field_verlag_Bedarf);
  StaticText5.Caption := inttostr(s_Field_verlag_Ist);
  StaticText6.Caption := inttostr(s_Field_verlag_Lager_used);


  EndHourGlass;
end;

procedure TFormVerlag.Button8Click(Sender: TObject);
begin
  EnsureSystemLager;
end;

procedure TFormVerlag.EnsureSystemLager;
var
  PErson_R: integer;

  function e_w_EnsureSpecial(SpecialName: string): integer;
  var
    cPERSON: TIB_Cursor;
    qVERLAG: TIB_Query;
  begin

    //
    cPERSON := TIB_Cursor.create(self);
    with cPERSON do
    begin
      sql.add('select RID from PERSON where SUCHBEGRIFF=''' + SpecialName + '''');
      ApiFirst;
      if eof then
        result := -1
      else
        result := FieldByName('RID').AsInteger;
    end;
    cPERSON.free;

    //
    if (result = -1) then
    begin
      result := DataModuleeCommerce.e_w_PersonNeu;
      DataModuleeCommerce.e_x_sql('update PERSON set SUCHBEGRIFF=''' + SpecialName + ''' where RID=' + inttostr(result));
    end;

    //
    qVERLAG := TIB_Query.create(self);
    with qVERLAG do
    begin
      sql.add('select * from VERLAG where PERSON_R=' + inttostr(result) + ' for update');
      Open;
      First;
      if eof then
      begin
        append;
        FieldByName('RID').AsInteger := 0;
        FieldByName('PERSON_R').AsInteger := result;
        post;
      end;
      close;
    end;
    qVERLAG.free;

  end;

begin
  BeginHourGlass;
  e_w_EnsureSpecial(cVerlagUebergangsfach);
  e_w_EnsureSpecial(cVerlagFreiesLager);
  DataModuleeCommerce.e_w_InvalidateCaches;
  DisableCache;
  RefreshCData;
  EndHourGlass;
end;

procedure TFormVerlag.FormDestroy(Sender: TObject);
begin
  VerlagRID.free;
  VerlageBaseRID.free;
  SubCache.free;
  CalcLagerLog.free;
  _AllVerlageRID.free;
end;

end.

