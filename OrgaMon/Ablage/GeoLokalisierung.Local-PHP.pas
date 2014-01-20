//
// Umsetzung von "Strasse, PLZ Ort" zu "X, Y"
//
unit GeoLokalisierung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,
  php4delphi, FastGEO, HebuData,
  IB_Components, Buttons;

type
  TFormGeoLokalisierung = class(TForm)
    GroupBox1: TGroupBox;
    EditUser: TEdit;
    Editpwd: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    psvPHP1: TpsvPHP;
    Label1: TLabel;
    Button4: TButton;
    Label6: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label7: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo3: TMemo;
    Memo_Data: TMemo;
    StaticText2: TStaticText;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    RequestTime: dword;
    DisableCache: boolean;

    procedure ShowResult(p: Tpoint2D);

  public
    { Public-Deklarationen }
    DiagMode: boolean;
    OffLineMode: boolean; // =false*: ist nix in der Datenbank, so wird online nachgehakt!
                          // =true: nur in der Datenbank suchen!
    r_plz, q_plz: string;
    r_ortsteil, q_ortsteil: string;
    r_error: string;

    // locate mit Anhauen des
    function locate(Strasse, PLZ, Ort, Ortsteil: string; var p: TPoint2D): integer; { [POSTLEITZAHLEN_R] } overload;
    function locate(Strasse, PLZ_Ort, Ortsteil: string; var p: TPoint2D): integer; { [POSTLEITZAHLEN_R] } overload;
    function unlocate(POSTLEITZAHL_R: integer): integer;

  end;

var
  FormGeoLokalisierung: TFormGeoLokalisierung;

implementation

uses
  anfix32, globals, eCommerce,
  gplists, geoCache;

{$R *.dfm}

procedure TFormGeoLokalisierung.Button4Click(Sender: TObject);
var
  p: TPoint2D;
begin
  StaticText1.caption := '';
  DisableCache := CheckBox2.Checked;
  locate(edit4.text, edit2.text, edit3.text, '', p);
  ShowResult(p);
end;

procedure TFormGeoLokalisierung.Button1Click(Sender: TObject);
begin
  ShowMessage(format('%g', [Distance(
      8.41177,
      49.00937,
      8.39295,
      49.01005) *
    111.136]));
end;

function TFormGeoLokalisierung.locate(Strasse, PLZ, Ort, Ortsteil: string; var p: TPoint2D): integer;
var
  StrassenName: string;
  StrasseHausnummer: string;
  php: TStringList;
  ResultS: string;
  StartTime: Dword;
  EntryFound: boolean;
  POSTLEITZAHLEN_R: integer;

  //
  Diversitaet: boolean;
  StrasseID: int64;
  PLZl: TIntegerList;
  n: integer;
  PLZasInteger: integer;

  procedure CacheCheck(PLZ: integer);
  var
    cPLZ: TIB_Cursor;
  begin

    // in der Datenbank nach einem Eintrag mit Koordinaten suchen
    // es geht nur um die Strasse, nicht um die Hausnummerngenaue
    // Position, obwohl diese eingetragen ist!

    cPLZ := TIB_Cursor.create(self);
    with cPLZ do
    begin
      //
      sql.add('select RID,ORT,STRASSE,STRASSEID,X,Y,PLZ_DIVERSITAET,ORTSTEIL from POSTLEITZAHLEN where PLZ=' + inttostr(PLZ));
      ApiFirst;
      while not (eof) do
      begin

        if OrtIdentisch(Ort, FieldByName('ORT').AsString) then
        begin

          //
          if not (Diversitaet) then
            Diversitaet := (FieldByName('PLZ_DIVERSITAET').AsString = cc_True);

          //
          if StrasseIdentisch(StrassenName, ObtainStrassenName(FieldByName('STRASSE').AsString)) then
          begin

            //
            if FieldByName('STRASSEID').IsNotNull then
              StrasseID := trunc(FieldByName('STRASSEID').AsDouble);

            p.x := FieldByName('X').AsDouble;
            p.y := FieldByName('Y').AsDouble;
            if (p.x > 0) and (p.y > 0) then
            begin
              POSTLEITZAHLEN_R := FieldByName('RID').AsInteger;
              r_plz := inttostrN(plz, 5);
              r_ortsteil := FieldByName('ORTSTEIL').AsString;
              EntryFound := true;
              break;
            end;
          end;

        end;
        ApiNext;

      end;
    end;
    cPLZ.free;
  end;

  function Ansi2php(s: string): string;
  begin
    if CheckBox4.checked then
      result := AnsiToUtf8(s)
    else
    begin
      result := s;
      ersetze('ü', 'ue', result);
      ersetze('ä', 'ae', result);
      ersetze('ö', 'oe', result);
      ersetze('Ü', 'Ue', result);
      ersetze('Ä', 'Ae', result);
      ersetze('Ö', 'Oe', result);
      ersetze('ß', 'ss', result);
      ersetze(#160, ' ', result); // spezielles Blank!
    end;
  end;

begin
  //
  if DiagMode then
    BeginHourGlass;

  q_plz := PLZ;
  q_ortsteil := Ortsteil;
  POSTLEITZAHLEN_R := -1;
  p.x := -1;
  p.y := -1;
  repeat

    // Web-Service Ergebnisdaten
    r_plz := cImpossiblePLZ;
    r_ortsteil := '';
    r_error := 'OK';

    // erste Prüfung:
    PLZasInteger := strtointdef(PLZ, 0);
    if (length(PLZ) <> 5) or (PLZasInteger < 1) then
    begin
      // Fehler: Formatfehler in der PLZ
      r_error := 'PLZ unverständlich';
      break;
    end;

    // schon in der PLZ Tabelle?
    if DiagMode then
      StartTime := RDTSCms;

    // Split des Strassennamens von der Hausnummer!
    StrassenName := EnsureSQL(ObtainStrassenName(Strasse));
    StrasseHausnummer := EnsureSQL(ObtainStrassenHausNummer(Strasse));

    EntryFound := false;
    Diversitaet := false;
    StrasseID := -1;
    if not (DisableCache) and (PLZ <> cImpossiblePLZ) then
      CacheCheck(PLZasInteger);

    if EntryFound then
      break;

    // nicht gefunden
    if Diversitaet then
    begin

      // Lister aller Alternativ PLZ abfragen!
      if (StrasseID > 0) then
      begin
        PLZl := DataModuleeCommerce.e_r_sqlm('select distinct PLZ from POSTLEITZAHLEN ' +
          ' where ' +
          '(STRASSEID=' + inttostr(StrasseID) + ') and ' +
          '(PLZ_DIVERSITAET IS NOT NULL) and ' +
          '(PLZ<>' + PLZ + ')');
        for n := 0 to pred(PLZl.count) do
        begin
          CacheCheck(PLZl[n]);
          if EntryFound then
            break;
        end;
        PLZl.free;
      end else
      begin
       // WARNUNG: In einer vollständig bekannten PLZ (alle Strassen müssten da sein)
       //          wird eine Neue Strasse gesucht!
      end;
    end;

    if EntryFound then
      break;

    if OfflineMode then
      break;

    // call PHP
    if DiagMode then
      if not (visible) then
        show;

    with psvPHP1 do
    begin
      DLLFolder := ValidatePathName(MyApplicationPath);
      IniPath := ValidatePathName(phpPath);
    end;

    if DiagMode then
      memo_data.lines.clear;

    php := TStringList.create;
    php.loadfromFile(phpPath + 'locate.php');
    php.insert(0, '$user = "' + editUser.Text + '";');
    php.insert(0, '$pwd = "' + editpwd.text + '";');
    php.insert(0, '$X = "0";');
    php.insert(0, '$Y = "0";');
    php.insert(0, '$R_PLZ = "";');
    php.insert(0, '$R_ORTSTEIL = "";');

    if (PLZ <> '') and (PLZ <> cImpossiblePLZ) then
      php.Insert(0, '$plz = "' + PLZ + '";')
    else
      php.Insert(0, '$plz = null;');

    if (Ort <> '') then
      php.Insert(0, '$ort = "' + Ansi2php(Ort) + '";')
    else
      php.Insert(0, '$ort = null;');

    if (Ortsteil <> '') then
      php.Insert(0, '$ortsteil = "' + Ansi2php(Ortsteil) + '";')
    else
      php.Insert(0, '$ortsteil = null;');

    if (StrassenName <> '') then
      php.Insert(0, '$strasse = "' + Ansi2php(StrassenName) + '";')
    else
      php.Insert(0, '$strasse = null;');

    if (StrasseHausnummer <> '') then
      php.Insert(0, '$nummer = "' + StrasseHausnummer + '";')
    else
      php.Insert(0, '$nummer = null;');

    if Checkbox1.checked then
    begin
      php.Insert(0, '$PHPVER = shell_exec(''' + MyApplicationPath + 'php -v'');');
    end;

    php.Insert(0, '<?');
    php.add('?>');

    // PHP ausfindig machen
    if DiagMode then
    begin
      memo3.lines.assign(php);
      php.SaveToFile(phpPath + '0.php');
      application.processmessages;
    end;

    try
      with psvPHP1 do
      begin
        ResultS := RunCode(php);
        //
        p.x := VariableByName('X').AsFloat / cGEODEZIMAL_Faktor;
        p.y := VariableByName('Y').AsFloat / cGEODEZIMAL_Faktor;
        r_plz := VariableByName('R_PLZ').AsString;
        r_ortsteil := utf8toansi(VariableByName('R_ORTSTEIL').AsString);

        if DiagMode then
        begin
          if Checkbox1.checked then
          begin
            label6.caption := VariableByName('PHPVER').AsString;
          end;
        end;
        EntryFound := true;
      end;
    except
      r_error := 'PHP Problem';

     // Fehler: Probleme mit PHP
    end;

    //
    ersetze('<br />', #$0A, ResultS);
    if DIagMode then
    begin
      memo_data.Lines.add('Ergebnis R_PLZ: ' + r_plz);
      memo_data.Lines.add('Ergebnis R_ORTSTEIL: ' + r_ortsteil);

      while (ResultS <> '') do
        memo_data.Lines.add(nextp(ResultS, #$0A));
      Checkbox1.checked := false;
    end;
    php.Free;

    // letzte Plausibilitätskontrolle
    if (PLZ <> r_plz) and (PLZ <> cImpossiblePLZ) then
    begin
      r_error := 'OrgaMon PLZ falsch';
      // Fehler: Umlokalisierung durch den Geo Webservice
      //         ups? was ist passiert!
      //         Das Ergebnis wurde in einen anderen Bereich umverlegt!
      //         Gibt es diese PLZ nicht?! PLZ sind eigentlich unser Anker!
      p.x := 0;
      p.y := 0;
      if DiagMode then
      begin
        memo_data.lines.add('Neue PLZ: ' +
          r_plz + ' ' +
          r_ortsteil);
      end;
      break;
    end;

    if not (EntryFound) then
      break;

    // Ergebnis dauerhaft abspeichern!
    try
      n := DataModuleeCommerce.e_w_GEN('GEN_POSTLEITZAHLEN');
      DataModuleeCommerce.e_x_sql('insert into POSTLEITZAHLEN (RID,PLZ,ORT,ORTSTEIL,STRASSE,X,Y,EINTRAG) values (' +
        inttostr(n) + ',' +
        '''' + PLZ + ''',' +
        '''' + EnsureSQL(Ort) + ''',' +
        '''' + EnsureSQL(r_Ortsteil) + ''',' +
        '''' + EnsureSQL(Strasse) + ''',' +
        FloatToStrISO(p.x) + ',' +
        FloatToStrISO(p.y) + ',' +
        '''now'')');
      POSTLEITZAHLEN_R := n;
    except
      r_error := 'Datenbank Problem';

     // Fehler: Datenbank Eintrag war nicht möglich!
    end;

  until true;

  // ##########
  if Diagmode then
  begin
    RequestTime := RDTSCms - StartTime;
    if (visible) then
      ShowResult(p);
    EndHourGlass;
    if not (DisableCache) then
      close;
  end;
  result := POSTLEITZAHLEN_R;
  OffLineMode := false;
end;

function TFormGeoLokalisierung.locate(Strasse, PLZ_Ort, Ortsteil: string; var p: TPoint2D): integer;
begin
  p.x := -1;
  p.y := -1;
  if (pos(' ', PLZ_ORT) = 6) then
    result := locate(Strasse, copy(PLZ_ORT, 1, 5), copy(PLZ_ORT, 7, MaxInt), Ortsteil, p)
  else
    result := locate(Strasse, cImpossiblePLZ, copy(PLZ_ORT, 1, MaxInt), Ortsteil, p);
end;

procedure TFormGeoLokalisierung.ShowResult(p: Tpoint2D);
begin
  statictext2.caption := format('%d ms Abfragedauer', [RequestTime]);
  statictext1.caption := format('%g;%g', [p.x, p.y]);
end;

procedure TFormGeoLokalisierung.SpeedButton1Click(Sender: TObject);
begin
  open(phpPath);
end;

function TFormGeoLokalisierung.unlocate(POSTLEITZAHL_R: integer): integer;
begin
 DataModuleeCommerce.e_w_unlocate(POSTLEITZAHL_R);
end;

procedure TFormGeoLokalisierung.Button2Click(Sender: TObject);
var
  s: TStringList;
  d: TStringlist;
  n: integer;
  _ort: string;
  _strasse: string;
begin
  s := TStringList.create;
  s.LoadFromFile(OLAPPATH + 'OLAP.tmp0.csv');
  d := TStringlist.create;
  for n := 1 to pred(s.count) do
  begin
    _ort := ExtractSegmentBetween(nextp(s[n], ';', 0), '"', '"');
    _strasse := ExtractSegmentBetween(nextp(s[n], ';', 1), '"', '"');
    d.add(nextp(_ort, ' ') + ' ' + ObtainStrassenName(_Strasse));
  end;
  d.sort;
  removeduplicates(d);
  d.SaveTofile(OLAPPATH + 'OLAP.tmp1.csv');
  d.free;
  s.free;
end;

procedure TFormGeoLokalisierung.Button3Click(Sender: TObject);
var
  cPOSTLEITZAHLEN: TIB_Cursor;

  RIDS: TIntegerList;
  n: integer;
  CompareStr: string;
  _CompareStr: string;
  p: TPoint2D;
begin
  BeginHourGlass;

 //
 // 1) * Identische Geodateneinträge löschen
 //    * Punkte ausserhalb Deutschlands löschen
 //
  RIDS := TIntegerList.create;
  cPOSTLEITZAHLEN := TIB_Cursor.create(self);
  with cPOSTLEITZAHLEN do
  begin
    sql.add('select RID,plz,ort,strasse,x,y from POSTLEITZAHLEN where');
    sql.add(' (x is not null) and');
    sql.add(' (y is not null)');
    sql.add('order by x,y,eintrag desc');
    _CompareStr := '';
    ApiFirst;
    while not (eof) do
    begin
      p.x := FieldByName('X').AsDouble;
      p.y := FieldByName('Y').AsDouble;

      CompareStr := FieldByName('PLZ').AsString + ';' +
        FieldByName('ORT').AsString + ';' +
        FieldByName('STRASSE').AsString;

      repeat

        // das gleiche wie eben?!
        if (CompareStr = _CompareStr) then
        begin
          RIDs.add(FieldByName('RID').AsInteger);
          break;
        end else
        begin
          _CompareStr := CompareStr;
        end;

        // ev. ausserhalb von Deutschland?
        if not (inDE(p)) then
        begin
          RIDs.add(FieldByName('RID').AsInteger);
        end;

      until true;

      apinext;
    end;
  end;
  cPOSTLEITZAHLEN.free;

  // eigentliche Löschung durchführen!
  for n := 0 to pred(RIDs.count) do
  begin
    DatamoduleeCommerce.e_x_dereference('ABLAGE.POSTLEITZAHL_R', inttostr(RIDs[n]));
    DatamoduleeCommerce.e_x_dereference('AUFTRAG.POSTLEITZAHL_R', inttostr(RIDs[n]));
    DatamoduleeCommerce.e_x_sql('delete from POSTLEITZAHLEN where RID=' + inttostr(RIDs[n]));
  end;
  RIDs.free;

  EndHourGlass;
end;

procedure TFormGeoLokalisierung.Button5Click(Sender: TObject);
var
  cPLZ: TIB_Cursor;
  POSTLEITZAHL_R: integer;
  StartTime: dword;
  p: TPoint2d;
begin
  //
  BeginHourGlass;
  StartTime := 0;
  cPLZ := TIB_Cursor.create(self);
  with cPLZ do
  begin
    //
    sql.add('select PLZ,ORT,STRASSE from POSTLEITZAHLEN where PLZ_DIVERSITAET IS NOT NULL');
    ApiFirst;
    while not (eof) do
    begin
      repeat
        OffLineMode := true;
        POSTLEITZAHL_R := locate(FieldByName('STRASSE').AsString, FieldByName('PLZ').AsString, FieldByName('ORT').AsString, '', p);
        if (POSTLEITZAHL_R > 0) then
        begin
          // a) Deref!
          DatamoduleeCommerce.e_x_dereference('ABLAGE.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));
          DatamoduleeCommerce.e_x_dereference('AUFTRAG.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));

          // b) set x,y = null
          DatamoduleeCommerce.e_x_sql('update POSTLEITZAHLEN set X=null,y=null,eintrag=null where RID=' + inttostr(POSTLEITZAHL_R));
        end else
        begin
          break;
        end;
      until false;
      apinext;
      if frequently(StartTime, 333) or eof then
      begin
        application.processmessages;
        StaticText2.caption := FieldByName('PLZ').AsString + ' ' + FieldByName('STRASSE').AsString;
      end;
    end;
  end;
  cPLZ.free;
  EndHourGlass;
end;

procedure TFormGeoLokalisierung.CheckBox3Click(Sender: TObject);
begin
  DiagMode := CheckBox3.checked;
end;

end.

