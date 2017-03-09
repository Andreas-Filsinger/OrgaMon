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
unit AuftragGeo;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls,
  Buttons, ComCtrls, FastGeo,
  GeoCache, JvGIF;

type
  TFormAuftragGeo = class(TForm)
    Image1: TImage;
    ComboBox1: TComboBox;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    Label5: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button4: TButton;
    Memo1: TMemo;
    Label7: TLabel;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Button5: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    Image2: TImage;
    SpeedButton5: TSpeedButton;
    CheckBox5: TCheckBox;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    Label2: TLabel;
    Memo2: TMemo;
    ComboBox2: TComboBox;
    CheckBox9: TCheckBox;
    Image3: TImage;
    Button1: TButton;
    CheckBox10: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button3: TButton;
    Label3: TLabel;
    Button6: TButton;
    ComboBox3: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    IsRunning: boolean;
    BreakIt: boolean;
    GeoCache: TGeoCache;

    procedure FuelleBaustellenCombo;
  public
    { Public-Deklarationen }

    procedure InitGeo;
    function Aufbereiten: boolean;
    procedure mShow;

  end;

var
  FormAuftragGeo: TFormAuftragGeo;

implementation

uses
  GeoLokalisierung, anfix32, IB_Components,
  IB_Access, globals, dbOrgaMon,
  GeoArbeitsplatz,
  CareTakerClient, AuftragArbeitsplatz, gplists,
  WordIndex, Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  wanfix32, IBExcel;

{$R *.dfm}

procedure TFormAuftragGeo.FormActivate(Sender: TObject);
begin
  if (ComboBox1.items.count = 0) then
    FuelleBaustellenCombo;
end;

procedure TFormAuftragGeo.FuelleBaustellenCombo;
var
  AktiveBaustellen: TStringList;

  procedure FillCombo(cb: TComboBox);
  var
    n: integer;
  begin
    cb.items.clear;
    cb.items.add('*');
    for n := 0 to pred(AktiveBaustellen.count) do
      cb.items.add(AktiveBaustellen[n]);
  end;

begin
  AktiveBaustellen := e_r_BaustellenAktive;
  FillCombo(ComboBox1);
  FillCombo(ComboBox2);
  FillCombo(ComboBox3);
  AktiveBaustellen.free;
end;

procedure TFormAuftragGeo.SpeedButton2Click(Sender: TObject);
begin
  //
  BeginHourGlass;
  ReCreateAktiveBaustellen;
  FuelleBaustellenCombo;
  EndHourGlass;
end;

procedure TFormAuftragGeo.Button1Click(Sender: TObject);
begin
  FormGeoArbeitsplatz.Test;
end;

procedure TFormAuftragGeo.Button2Click(Sender: TObject);
var
  cPLZ: TIB_Cursor;
  _LupenModus: boolean;
begin
  //
  BeginHourGlass;
  InitGeo;
  _LupenModus := GeoCache.LupenModus;
  GeoCache.LupenModus := false;

  cPLZ := DataModuleDatenbank.nCursor;
  with cPLZ do
  begin
    sql.add('select x,y from postleitzahlen where');
    sql.add(' (x is not null) and');
    sql.add(' (y is not null)');
    ApiFirst;
    while not(eof) do
    begin
      GeoCache.Kreuzchen(FieldByName('X').AsDouble, FieldByName('Y').AsDouble,
        Image1.canvas);
      ApiNext;
    end;
  end;
  cPLZ.free;
  GeoCache.LupenModus := _LupenModus;
  EndHourGlass;
end;

procedure TFormAuftragGeo.Button3Click(Sender: TObject);
begin
  BreakIt := true;
end;

procedure TFormAuftragGeo.Button4Click(Sender: TObject);
var
  Zoom: integer;
  p: TPoint2D;
begin
  if not(IsRunning) then
  begin
    Button4.Enabled := false;
    IsRunning := true;
    BreakIt := false;
    repeat

      // Daten vorbereiten
      if not(Aufbereiten) then
        if not(CheckBox7.checked) then
          break;

      if BreakIt then
        break;

      if not(CheckBox8.checked) then
        break;

      // erster Zoom annähern ...
      Zoom := round((GeoCache.breite * 2800) / 4.11762);

      // Jetzt in den Geo-Arbeitsplatz wechseln
      GeoCache.LupenModus := true;
      FormGeoArbeitsplatz.Geo := GeoCache;
      p := GeoCache.naechster(GeoCache.Zentrum);
      FormGeoArbeitsplatz.ShowMap(p.x, p.y, 25);

    until true;
    IsRunning := false;
    Button4.Enabled := true;
  end;
end;

procedure TFormAuftragGeo.InitGeo;
begin
  //
  if not(assigned(GeoCache)) then
  begin
    // Geo Objekt Initialisieren
    GeoCache := TGeoCache.create;
  end
  else
    GeoCache.clear;

  // Bild-Dimensionen immer eintragen!
  with GeoCache do
  begin
    iWidth := Image1.width;
    iHeight := Image1.Height;
  end;
end;

procedure TFormAuftragGeo.mShow;
begin
  WindowState := wsNormal;
  show;
end;

procedure TFormAuftragGeo.Button5Click(Sender: TObject);
var
  ListL: TStringList;
  qAUFTRAG: TIB_Query;
  n: integer;
  PLANQUADRAT: string;
begin
  BeginHourGlass;
  ListL := TStringList.create;
  ListL.LoadfromFile(DiagnosePath + 'Geo-Route-' + Edit1.text + '.csv');
  qAUFTRAG := DataModuleDatenbank.nQuery;
  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF for update');
    open;
    for n := 1 to pred(ListL.count) do
    begin
      PLANQUADRAT := nextp(ListL[n], ';', 1);
      ParamByName('CROSSREF').AsInteger :=
        strtointdef(nextp(ListL[n], ';', 0), 0);
      if not(eof) then
      begin
        if (FieldByName('PLANQUADRAT').AsString <> PLANQUADRAT) then
        begin
          edit;
          if (PLANQUADRAT <> '') then
            FieldByName('PLANQUADRAT').AsString := PLANQUADRAT
          else
            FieldByName('PLANQUADRAT').clear;
          AuftragBeforePost(qAUFTRAG);
          post;
        end;
      end;
    end;
  end;
  ListL.free;
  qAUFTRAG.free;
  EndHourGlass;
end;

procedure TFormAuftragGeo.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Geoarbeitsplatz');
end;

procedure TFormAuftragGeo.SpeedButton1Click(Sender: TObject);
begin
  with CheckBox1 do
    checked := not(checked);
end;

procedure TFormAuftragGeo.SpeedButton3Click(Sender: TObject);
begin
  with CheckBox2 do
    checked := not(checked);
end;

procedure TFormAuftragGeo.SpeedButton4Click(Sender: TObject);
begin
  with CheckBox4 do
    checked := not(checked);
end;

procedure TFormAuftragGeo.SpeedButton5Click(Sender: TObject);
begin
  with CheckBox5 do
    checked := not(checked);
end;

procedure TFormAuftragGeo.SpeedButton6Click(Sender: TObject);
begin
  openShell(DiagnosePath);
end;

procedure TFormAuftragGeo.SpeedButton7Click(Sender: TObject);
begin
  with CheckBox6 do
    checked := not(checked);
end;

function TFormAuftragGeo.Aufbereiten: boolean;
var
  cBAUSTELLE: TIB_Cursor;
  qAUFTRAG: TIB_Query;
  BAUSTELLE1a_R: integer;
  BAUSTELLE1b_R: integer;
  BAUSTELLE2_R: integer;
  Baustellen: TgpIntegerList;
  BAUSTELLE_R: integer;
  AUFTRAG_R: integer;
  POSTLEITZAHL_R: integer;
  BRIEF_ORT: string;
  KUNDE_ORT: string;
  p: TPoint2D;
  ProblemRIDs: TgpIntegerList;
  RecN: integer;
  StartTime: dword;
  InternInfo: TStringList;
  InfoMode: boolean;
  InfoUndMode: boolean;
  n: integer;
  FilterPassed: boolean;
  FilterValues: TSearchStringList;
begin

  BeginHourGlass;
  InitGeo;
  BAUSTELLE1a_R := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox1.text));
  BAUSTELLE1b_R := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox3.text));
  BAUSTELLE2_R := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox2.text));

  RecN := 0;
  StartTime := 0;
  ProblemRIDs := TgpIntegerList.create;
  FilterValues := TSearchStringList.create;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  Baustellen := TgpIntegerList.create;
  try

    // Wird auch über ZählerInfo selektiert?
    InfoUndMode := false;
    InfoMode := false;
    with Memo2 do
      for n := pred(lines.count) downto 0 do
        if noblank(lines[n]) <> '' then
        begin
          InfoMode := true;
          break;
        end
        else
        begin
          lines.delete(n);
        end;

    if InfoMode and CheckBox10.checked then
    begin
      InfoMode := false;
      InfoUndMode := true;
    end;

    with cBAUSTELLE do
    begin

      GeoCache.clear;
      GeoCache.LupenModus := false;

      // Standard SQL
      sql.add('select');
      sql.add(' A.RID,');
      if InfoMode or InfoUndMode then
      begin
        if RadioButton1.checked then
          sql.add(' A.ZAEHLER_INFO as INFO,');
        if RadioButton2.checked then
          sql.add(' A.MONTEUR_INFO as INFO,');
        if RadioButton3.checked then
          sql.add(' A.INTERN_INFO as INFO,');
      end;
      sql.add(' A.STATUS,');
      sql.add(' A.VORMITTAGS,');
      sql.add(' A.AUSFUEHREN,');
      sql.add(' A.KUNDE_STRASSE,');
      sql.add(' A.KUNDE_ORT,');
      sql.add(' A.KUNDE_ORTSTEIL,');
      sql.add(' A.POSTLEITZAHL_R,');
      sql.add(' A.BAUSTELLE_R,');
      sql.add(' P.X,');
      sql.add(' P.Y,');
      sql.add(' P.ORTSTEIL');
      sql.add('from');
      sql.add(' AUFTRAG A');
      sql.add('left join POSTLEITZAHLEN P on P.RID=A.POSTLEITZAHL_R');
      sql.add('WHERE');

      if (BAUSTELLE1a_R >= cRID_FirstValid) then
        Baustellen.add(BAUSTELLE1a_R);
      if (BAUSTELLE1b_R >= cRID_FirstValid) then
        Baustellen.add(BAUSTELLE1b_R);
      if (BAUSTELLE2_R >= cRID_FirstValid) then
        Baustellen.add(BAUSTELLE2_R);

      if Baustellen.count = 1 then
        sql.add(' (A.BAUSTELLE_R=' + inttostr(Baustellen[0]) + ') and')
      else
        sql.add(' (A.BAUSTELLE_R in ' + ListasSQL(Baustellen) + ') and');

      sql.add(' (A.STATUS <> 6)');

      // Benutzerdefinierten Code noch hinzu
      if (cutblank(HugeSingleLine(Memo1.lines, '')) <> '') then
      begin
        sql.add('and');
        sql.AddStrings(Memo1.lines);
      end;

      if CheckBox3.checked then
        sql.SaveToFile(DiagnosePath + 'geo.sql');

      ProgressBar1.max := RecordCount;
      ApiFirst;
      while not(eof) do
      begin

        BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;

        FilterPassed := true;
        repeat

          // Filter "1"
          if InfoMode then
          begin
            //
            FilterPassed := false;
            FieldByName('INFO').AssignTo(FilterValues);
            with Memo2 do
              for n := 0 to pred(lines.count) do
                if (FilterValues.FindInc(lines[n]) <> -1) then
                begin
                  FilterPassed := true;
                  break;
                end;
          end;

          // Filter "2"
          if InfoUndMode then
          begin
            //
            FilterPassed := true;
            FieldByName('INFO').AssignTo(FilterValues);
            with Memo2 do
              for n := 0 to pred(lines.count) do
                if (FilterValues.FindInc(lines[n]) = -1) then
                begin
                  FilterPassed := false;
                  break;
                end;
          end;

        until true;

        if FilterPassed then
        begin

          AUFTRAG_R := FieldByName('RID').AsInteger;
          KUNDE_ORT := FieldByName('KUNDE_ORT').AsString;
          p.x := FieldByName('X').AsDouble;
          p.y := FieldByName('Y').AsDouble;

          if not(InDE(p)) then
          begin

            // Unbestimmter Punkt!
            // Nachtragen!
            POSTLEITZAHL_R := FormGeoLokalisierung.locate(
              { } FieldByName('KUNDE_STRASSE').AsString,
              { } KUNDE_ORT,
              { } FieldByName('KUNDE_ORTSTEIL').AsString,
              { } p);

            if (POSTLEITZAHL_R >= cRID_FirstValid) then
            begin

              // eintragen
              e_x_sql('update AUFTRAG set ' + 'POSTLEITZAHL_R=' +
                inttostr(POSTLEITZAHL_R) + ' ' + 'where RID=' +
                inttostr(AUFTRAG_R));

              // Ortsteil nachtragen!
              if (FieldByName('KUNDE_ORTSTEIL').AsString = '') then
                if (FormGeoLokalisierung.r_ortsteil <> '') then
                  e_x_sql('update auftrag set KUNDE_ORTSTEIL = ''' +
                    FormGeoLokalisierung.r_ortsteil + ''' where RID=' +
                    inttostr(AUFTRAG_R));

              // PLZ nachtragen

              if (FormGeoLokalisierung.q_PLZ = cImpossiblePLZ) then
                if (FormGeoLokalisierung.r_PLZ <> '') then
                  if (pos('@', KUNDE_ORT) = 0) then
                  begin
                    BRIEF_ORT :=
                      e_r_sqls('select BRIEF_ORT from AUFTRAG where RID=' +
                      inttostr(AUFTRAG_R));

                    if (BRIEF_ORT = KUNDE_ORT) then
                    begin
                      e_x_sql('update auftrag set KUNDE_ORT = ''' +
                        { } FormGeoLokalisierung.r_PLZ + ' ' +
                        cutblank(KUNDE_ORT) + ''',' + 'BRIEF_ORT = ''' +
                        { } FormGeoLokalisierung.r_PLZ + ' ' +
                        cutblank(KUNDE_ORT) + ''' where RID=' +
                        inttostr(AUFTRAG_R));
                    end
                    else
                    begin
                      e_x_sql('update auftrag set KUNDE_ORT = ''' +
                        { } FormGeoLokalisierung.r_PLZ + ' ' +
                        cutblank(KUNDE_ORT) + ''' where RID=' +
                        inttostr(AUFTRAG_R));
                    end;
                  end;

            end
            else
            begin

              // Fehler passiert!
              p.x := -1;
              p.y := -1;

              // alte Referenz austragen
              if FieldByName('POSTLEITZAHL_R').IsNotNull then
              begin
                e_x_sql('update AUFTRAG set ' + 'POSTLEITZAHL_R=NULL ' +
                  'where RID=' + inttostr(AUFTRAG_R));
              end;

              // vom Fehler berichten:
              case POSTLEITZAHL_R of
                - 1:
                  begin
                    InternInfo := TStringList.create;
                    qAUFTRAG := DataModuleDatenbank.nQuery;
                    with qAUFTRAG do
                    begin

                      //
                      sql.add('select * from AUFTRAG where RID=' +
                        inttostr(AUFTRAG_R));
                      sql.add('for update');

                      //
                      open;
                      First;
                      FieldByName('INTERN_INFO').AssignTo(InternInfo);
                      InternInfo.values['GEO_PLZ'] :=
                        FormGeoLokalisierung.r_PLZ;
                      InternInfo.values['GEO_ORTSTEIL'] :=
                        FormGeoLokalisierung.r_ortsteil;
                      InternInfo.values['GEO_SAGT'] :=
                        FormGeoLokalisierung.r_error;
                      edit;

                      //
                      if (FormGeoLokalisierung.q_PLZ = cImpossiblePLZ) and
                        (FormGeoLokalisierung.r_PLZ <> cImpossiblePLZ) then
                        FieldByName('KUNDE_ORT').AsString :=
                          FormGeoLokalisierung.r_PLZ + ' ' +
                          cutblank(FieldByName('KUNDE_ORT').AsString);

                      //
                      if (FieldByName('KUNDE_ORTSTEIL').AsString = '') then
                        FieldByName('KUNDE_ORTSTEIL').AsString :=
                          FormGeoLokalisierung.r_ortsteil;

                      FieldByName('INTERN_INFO').assign(InternInfo);
                      AuftragBeforePost(qAUFTRAG);
                      post;
                      Close;
                    end;
                    qAUFTRAG.free;
                    InternInfo.free;

                    ProblemRIDs.add(AUFTRAG_R);
                  end;
                -2:
                  begin
                    if CheckBox9.checked then
                      ProblemRIDs.add(AUFTRAG_R);

                  end;
              end; // case
            end;
          end;

          if InDE(p) then
          begin

            GeoCache.Kreuzchen(p, Image1.canvas);

            if (BAUSTELLE_R = BAUSTELLE1a_R) or (BAUSTELLE_R = BAUSTELLE1b_R)
            then
            begin

              // Filter Code --------------- BEGIN
              if {} FieldByName('AUSFUEHREN').IsNull or
                 {} FieldByName('VORMITTAGS').IsNull or
                 {} (FieldByName('STATUS').AsInteger in [
                 {}  cs_DatenFehlen,
                 {}  cs_NeuAnschreiben,
                 {}  cs_Restant]) then
              begin

                // normale berührbare!
                case FieldByName('STATUS').AsInteger of
                  cs_Restant:
                    begin
                      if CheckBox5.checked then
                        GeoCache.add(p, AUFTRAG_R, cPunkt_gelb, 3, true);
                    end;
                  cs_NeuAnschreiben:
                    begin
                      if CheckBox4.checked then
                        GeoCache.add(p, AUFTRAG_R, cPunkt_lila, 4, true);
                    end;
                  cs_Unmoeglich, cs_Vorgezogen, cs_Erfolg:
                    ;
                else
                  if CheckBox6.checked then
                    GeoCache.add(p, AUFTRAG_R, cPunkt_gruen, 2, true);
                end;

              end
              else
              begin

                // weise und graue
                if (FieldByName('AUSFUEHREN').AsDate >= trunc(Date)) then
                begin

                  // heute, oder in Zukunft
                  if CheckBox2.checked then
                    GeoCache.add(p, AUFTRAG_R, cPunkt_weiss, 1, false);
                end
                else
                begin

                  // gestern oder was anderes
                  if CheckBox1.checked then
                    GeoCache.add(p, AUFTRAG_R, cPunkt_grau, 0, false);
                end;
              end;
            end
            else
            begin

              // andere Baustelle
              if FieldByName('AUSFUEHREN').IsNUll or FieldByName('VORMITTAGS')
                .IsNUll or (FieldByName('STATUS').AsInteger in [cs_DatenFehlen,
                cs_NeuAnschreiben, cs_Restant]) then
                GeoCache.add(p, AUFTRAG_R, cPunkt_Mint, 0, false);
            end;
          end;
        end;

        ApiNext;
        if frequently(StartTime, 333) or eof then
        begin
          Label2.caption := format('%d/%d/%d', [RecN, ProblemRIDs.count,
            ProgressBar1.max]);
          application.processmessages;
          ProgressBar1.position := RecN;
          if BreakIt then
            break;
        end;
        inc(RecN);

      end;

    end;

    with GeoCache do
    begin
      Paint(Image1.canvas);
      StaticText1.caption := format('%.2f km', [breite]);
      StaticText2.caption := format('%.2f km', [Hoehe]);
    end;

  except
    on E: Exception do
    begin
      if CheckBox3.checked then
        ShowMEssage(E.Message);
    end;
  end;

  // Diagnose:
  if CheckBox3.checked then
  begin
    Close;
    ExportTable(cBAUSTELLE.sql, DiagnosePath + 'geo.csv');
    ExportTableAsXLS(cBAUSTELLE.sql, DiagnosePath + 'geo.xls');
  end;

  ProgressBar1.position := 0;
  EndHourGlass;

  if (ProblemRIDs.count > 0) then
  begin
    if doit('WARNUNG: Es konnte nicht alle Datensätze lokalisiert werden!' + #13
      + '* Falls Sie "+ diagnose" angehakt haben:' + #13 +
      '  Öffnen Sie im Excel die Datei .\diagnose\geo.csv' + #13 +
      '  Sortieren sie nach x,y' + #13 +
      '  Suchen Sie fragliche Datensätze mit x=0,y=0 durch Sucheingabe RIDnnnnn{,nnnnnn}'
      + #13 + '* Die fraglichen Daten jetzt direkt anzeigen') then
      FormAuftragArbeitsplatz.ShowRIDs(ProblemRIDs);
  end;

  result := (ProblemRIDs.count = 0);
  Baustellen.free;
  cBAUSTELLE.free;
  FilterValues.free;
  ProblemRIDs.free;
  Label2.caption := '#/#/#';
end;

end.
