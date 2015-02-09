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
unit DruckSpooler;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IB_Components,
  Grids, IB_Grid, IB_Access,
  ComCtrls, IB_UpdateBar, Buttons;

type
  TFormDruckSpooler = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    CheckBox1: TCheckBox;
    Button1: TButton;
    IB_Grid1: TIB_Grid;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    IB_UpdateBar1: TIB_UpdateBar;
    SpeedButton4: TSpeedButton;
    Button20: TButton;
    Label2: TLabel;
    Button7: TButton;
    Button8: TButton;
    TabSheet3: TTabSheet;
    ListBox2: TListBox;
    Button4: TButton;
    SpeedButton12: TSpeedButton;
    Button5: TButton;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Button6: TButton;
    Button11: TButton;
    Button9: TButton;
    SpeedButton8: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
  private
    { Private-Deklarationen }
    TimerState: integer;
    JobIsRunning: boolean;
    USerBreak: boolean;
    // für resolve, globale Context Objekte
    JobIsAbout: integer;
    cARTIKEL: TIB_Cursor;
    cLAGER: TIB_Cursor;
    cWARENBEWEGUNG: TIB_Cursor;
    cBELEG: TIB_Cursor;
    cPERSON: TIB_Cursor;
    cANSCHRIFT: TIB_Cursor;
    cADRESSE: TStringList;

    procedure Log(const s: string);
    procedure refreshDruckauftraege;

  public
    { Public-Deklarationen }
    procedure DoJob;
  end;

var
  FormDruckSpooler: TFormDruckSpooler;

implementation

uses
  globals, anfix32, Funktionen_Basis,
  Funktionen_Beleg,
  basic32, CareTakerClient, Artikel,
  WarenBewegung, dbOrgaMon,
  wanfix32, Datenbank, main;

{$R *.dfm}

function Resolve(const VarName: ShortString): ShortString;
var
  sTable: string;
  sField: string;
  PERSON_R: integer;
  n: integer;
begin
 with FormDruckSpooler do
 begin
  if not(assigned(cLAGER)) then
  begin
    // defaults
    PERSON_R := cRID_Null;

    // Warenbewegung
    cWARENBEWEGUNG := DataModuleDatenbank.nCursor;
    with cWARENBEWEGUNG do
    begin
      sql.Add('select * from WARENBEWEGUNG where RID=' + inttostr(JobIsAbout));
      ApiFirst;
      if eof then
        Log('ERROR: Warenbewegung_R Referenz ungültig!');
    end;

    // Lager
    cLAGER := DataModuleDatenbank.nCursor;
    if not(cWARENBEWEGUNG.FieldByName('LAGER_R').IsNull) then
    begin
      with cLAGER do
      begin
        sql.Add('select * from LAGER where RID = ' + inttostr
            (cWARENBEWEGUNG.FieldByName('LAGER_R').AsInteger));
        ApiFirst;
        if eof then
          Log('ERROR: LAGER_R Referenz ungültig!');
      end;
    end;

    // Artikel
    cARTIKEL := DataModuleDatenbank.nCursor;
    if not(cWARENBEWEGUNG.FieldByName('ARTIKEL_R').IsNull) then
      with cARTIKEL do
      begin
        sql.Add('select * from ARTIKEL where RID = ' + inttostr
            (cWARENBEWEGUNG.FieldByName('ARTIKEL_R').AsInteger));
        ApiFirst;
        if eof then
          Log('ERROR: ARTIKEL_R Referenz ungültig!');
      end;

    // Beleg
    cBELEG := DataModuleDatenbank.nCursor;
    with cBELEG do
    begin
      sql.Add('select * from BELEG where RID=' + inttostr
          (cWARENBEWEGUNG.FieldByName('BELEG_R').AsInteger));
      ApiFirst;
      if not(eof) then
      begin
        if FieldByName('LIEFERANSCHRIFT_R').IsNull then
          PERSON_R := FieldByName('PERSON_R').AsInteger
        else
          PERSON_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;
      end;
    end;

    // Person
    cPERSON := DataModuleDatenbank.nCursor;
    if (PERSON_R >= cRID_FirstValid) then
      with cPERSON do
      begin
        sql.Add('select * from PERSON where RID=' + inttostr(PERSON_R));
        ApiFirst;
      end;

    // Anschrift
    cANSCHRIFT := DataModuleDatenbank.nCursor;
    if (PERSON_R >= cRID_FirstValid) then
      with cANSCHRIFT do
      begin
        sql.Add('select * from ANSCHRIFT where RID=' + inttostr
            (cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
        ApiFirst;
      end;

    // Adresse
    if (PERSON_R >= cRID_FirstValid) then
    begin
      cADRESSE := e_r_Adressat(PERSON_R);
      cADRESSE.Add(cANSCHRIFT.FieldByName('STRASSE').AsString);
      cADRESSE.Add(e_r_ort(cANSCHRIFT));
    end
    else
    begin
      cADRESSE := TStringList.create;
      for n := 0 to 5 do
        cADRESSE.Add('');
    end;

  end;

  sTable := nextp(VarName, '.', 0);
  sField := nextp(VarName, '.', 1);

  result := '?';
  try

    // Warenbewegung
    if (sTable = 'WARENBEWEGUNG') then
    begin
      repeat

        if (sField = 'ePreis') then
        begin
          result := e_r_PreisText
            (cWARENBEWEGUNG.FieldByName('AUSGABEART_R').AsInteger,
            cWARENBEWEGUNG.FieldByName('ARTIKEL_R').AsInteger);
          break;
        end;

        if cWARENBEWEGUNG.FieldByName(sField).IsNull then
          result := '0'
        else
          result := cWARENBEWEGUNG.FieldByName(sField).AsString;
      until true;
    end;

    // Artikel
    if (sTable = 'ARTIKEL') then
    begin
      repeat

        if (sField = 'ePreis') then
        begin
          result := e_r_PreisText(0,
            cARTIKEL.FieldByName('RID').AsInteger);
          break;
        end;

        if cARTIKEL.FieldByName(sField).IsNull then
          result := '0'
        else
          result := cARTIKEL.FieldByName(sField).AsString;
      until true;
    end;

    // Lager
    if (sTable = 'LAGER') then
      if cLAGER.active then
        result := cLAGER.FieldByName(sField).AsString
      else
        result := '';

    // Person
    if (sTable = 'PERSON') then
    begin
      if cPERSON.FieldByName(sField).IsNull then
        result := '0'
      else
        result := cPERSON.FieldByName(sField).AsString;
    end;

    // Anschrift
    if (sTable = 'ANSCHRIFT') then
    begin
      if cANSCHRIFT.FieldByName(sField).IsNull then
        result := '0'
      else
        result := cANSCHRIFT.FieldByName(sField).AsString;
    end;

    // Beleg
    if (sTable = 'BELEG') then
    begin
      if cBELEG.FieldByName(sField).IsNull then
        result := '0'
      else
        result := cBELEG.FieldByName(sField).AsString;
    end;

    // Adresse
    if (sTable = 'ADRESSE') then
    begin
      result := cADRESSE[strtoint(sField)];
    end;

  except
    on e: exception do
      Log('ERROR: ' + e.message);
  end;
      end;
end;

procedure TFormDruckSpooler.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure TFormDruckSpooler.Button11Click(Sender: TObject);
var
  n: integer;
  sMovePath: string;
begin
  with ListBox2 do
    if (items.count > 0) then
      if doit(
        'Sind alle Druckaufträge in ausreichender Anzahl einwandfrei ausgedruckt'
        ) then
      begin
        BeginHourGlass;
        sMovePath := inttostrN(e_w_GEN('GEN_TICKET'), 10)
          + '\';
        CheckCreateDir(MyProgramPath + cDruckauftragPath + sMovePath);
        for n := 0 to pred(items.count) do
          FileMove(MyProgramPath + cDruckauftragPath + items[n],
            MyProgramPath + cDruckauftragPath + sMovePath + items[n]);
        refreshDruckauftraege;
        EndHourGlass;
      end;
end;

procedure TFormDruckSpooler.Button1Click(Sender: TObject);
begin
  BeginHourGlass;
  DoJob;
  IB_Query1.Refresh;
  EndHourGlass;
end;

procedure TFormDruckSpooler.DoJob;
var
  qWARENBEWEGUNG: TIB_Query;
  cDRUCK: TIB_Cursor;
  _now: TDateTime;
  BASIC: TBasicProcessor;
  BASICName: string;
  PrintOK: boolean;
begin
  if not(JobIsRunning) then
  begin
    JobIsRunning := true;

    BeginHourGlass;

    Label2.Caption := inttostr(strtointdef(Label2.Caption, 0) + 1);

    //
    qWARENBEWEGUNG := DataModuleDatenbank.nQuery;
    with qWARENBEWEGUNG do
    begin
      _now := now;
      sql.Add('select * from WARENBEWEGUNG where GEDRUCKT IS NULL for update');
      Open;
      first;
      while not(eof) do
      begin

        //
        PrintOK := false;

        try

          JobIsAbout := FieldByName('RID').AsInteger;
          repeat

            // keine Zugangsmenge
            if (FieldByName('MENGE').AsInteger < 1) then
              break;

            //
            BASIC := TBasicProcessor.create;
            BASIC.PicturePath := MyProgramPath + cHTMLTemplatesDir;

            repeat

              // Reine Beleg-Buchung
              if FieldByName('ARTIKEL_R').IsNull then
              begin
                BASICName := cBelegbuchung;
                break;
              end;

              // Inventur-Label
              if FieldByName('MENGE_BISHER').IsNotNull then
                if (FieldByName('MENGE_BISHER').AsInteger = FieldByName
                    ('MENGE_NEU').AsInteger) then
                begin
                  BASICName := cInventur;
                  break;
                end;

              // allgemeiner Waren-Eingang
              if FieldByName('LAGER_R').IsNull then
              begin
                BASICName := cZugangsVorgang;
                break;
              end;

              // Waren-Eingang ins Lager oder ins Übergangsfach
              if e_r_IsUebergangsfach
                (FieldByName('LAGER_R').AsInteger) then
                BASICName := cZugangsVorgang + ' ' + cVerlagUebergangsfach
              else
                BASICName := cZugangsVorgang + ' ' + cLagerBegriff;

            until true;

            cDRUCK := DataModuleDatenbank.nCursor;
            with cDRUCK do
            begin
              sql.Add('select DEFINITION from DRUCK where NAME=''' +
                  BASICName + '''');
              ApiFirst;
              if eof then
                Log('WARNING: Druckstück "' + BASICName + '" nicht gefunden!')
              else
                FieldByName('DEFINITION').AssignTo(BASIC);
            end;
            cDRUCK.free;

            BASIC.WriteVal('ANZAHL', FieldByName('MENGE').AsString);
            BASIC.ResolveData := Resolve;
            BASIC.ResolveSQL := ResolveSQL;
            BASIC.RUN;
            BASIC.free;

            //
            FreeAndNil(cARTIKEL);
            FreeAndNil(cLAGER);
            FreeAndNil(cWARENBEWEGUNG);
            FreeAndNil(cBELEG);
            FreeAndNil(cPERSON);
            FreeAndNil(cANSCHRIFT);
            FreeAndNil(cADRESSE);

            PrintOK := true;

          until true;
        except
          on e: exception do
            Log('ERROR: ' + e.message);
        end;

        edit;
        if PrintOK then
        begin
          FieldByName('GEDRUCKT').AsDateTime := _now;
          FieldByName('BEWEGT').AsString := cC_True;
        end
        else
        begin
          FieldByName('GEDRUCKT').AsDateTime := Date;
        end;
        post;

        next;
      end;
      close;
    end;
    qWARENBEWEGUNG.free;

    EndHourGlass;

    JobIsRunning := false;
  end;
end;

procedure TFormDruckSpooler.TabSheet3Show(Sender: TObject);
begin
  refreshDruckauftraege;
end;

procedure TFormDruckSpooler.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  if AllSystemsRunning then
  begin

    //
    case TimerState of
      0:
        begin

          // Check if service is wanted
          Timer1.Enabled := not(pDisableDrucker) and
            (AnsiUpperCase(ComputerName) = AnsiUpperCase(iLabelHost)
            );
          CheckBox1.Checked := Timer1.Enabled;
          if Timer1.enabled then
           FormMain.panel6.color := cllime;

          //
          inc(TimerState);

        end;
      1:
        begin

          // Check if there a Print-Pieces, if not -> don't print
          Timer1.interval := 20000;
          inc(TimerState);

        end;
      2:
        begin

          //
          DoJob;
        end;
    end;
  end;
end;


procedure TFormDruckSpooler.Button20Click(Sender: TObject);
var
  cWARENBEWEGUNG: TIB_Cursor;
  BASIC: TBasicProcessor;
  BASICName: string;
  cDRUCK: TIB_Cursor;

begin
  JobIsAbout := IB_Query1.FieldByName('RID').AsInteger;

  cWARENBEWEGUNG := DataModuleDatenbank.nCursor;

  with cWARENBEWEGUNG do
  begin
    sql.Add('select * from WARENBEWEGUNG where RID=' + inttostr(JobIsAbout));
    ApiFirst;

    repeat

      // keine Zugangsmenge
      if (FieldByName('MENGE').AsInteger < 1) then
        break;

      //
      BASIC := TBasicProcessor.create;
      BASIC.PicturePath := MyProgramPath + cHTMLTemplatesDir;
      BASIC.DeviceOverride := iTestDrucker;

      repeat

        // Reine Beleg-Buchung
        if FieldByName('ARTIKEL_R').IsNull then
        begin
          BASICName := cBelegbuchung;
          break;
        end;

        // Inventur-Label
        if FieldByName('MENGE_BISHER').IsNotNull then
          if (FieldByName('MENGE_BISHER').AsInteger = FieldByName('MENGE_NEU')
              .AsInteger) then
          begin
            BASICName := cInventur;
            break;
          end;

        // allgemeiner Waren-Eingang
        if FieldByName('LAGER_R').IsNull then
        begin
          BASICName := cZugangsVorgang;
          break;
        end;

        // Waren-Eingang ins Lager oder ins Übergangsfach
        if e_r_IsUebergangsfach
          (FieldByName('LAGER_R').AsInteger) then
          BASICName := cZugangsVorgang + ' ' + cVerlagUebergangsfach
        else
          BASICName := cZugangsVorgang + ' ' + cLagerBegriff;

      until true;

      cDRUCK := DataModuleDatenbank.nCursor;
      with cDRUCK do
      begin
        sql.Add('select DEFINITION from DRUCK where NAME=''' + BASICName +
            '''');
        ApiFirst;
        if eof then
          Log('WARNING: Druckstück "' + BASICName + '" nicht gefunden!')
        else
          FieldByName('DEFINITION').AssignTo(BASIC);
      end;
      cDRUCK.free;

      BASIC.WriteVal('ANZAHL', FieldByName('MENGE').AsString);
      BASIC.ResolveData := Resolve;
      BASIC.ResolveSQL := ResolveSQL;
      BASIC.RUN;
      BASIC.free;

      //
      FreeAndNil(cARTIKEL);
      FreeAndNil(cLAGER);
      FreeAndNil(cWARENBEWEGUNG);
      FreeAndNil(cBELEG);
      FreeAndNil(cPERSON);
      FreeAndNil(cANSCHRIFT);
      FreeAndNil(cADRESSE);

    until true;
  end;
  cWARENBEWEGUNG.free;
end;

procedure TFormDruckSpooler.Button2Click(Sender: TObject);
var
  dWARENBEWEGUNG: TIB_DSQL;
begin
  BeginHourGlass;
  dWARENBEWEGUNG := DataModuleDatenbank.nDSQL;
  with dWARENBEWEGUNG do
  begin
    sql.Add('update WARENBEWEGUNG set GEDRUCKT=''NOW'' where GEDRUCKT IS NULL');
    execute;
  end;
  dWARENBEWEGUNG.free;
  IB_Query1.Refresh;
  EndHourGlass;
end;

procedure TFormDruckSpooler.Button3Click(Sender: TObject);
begin
  // IB_Query1.ParamByName('CROSSREF').AsDate := long2datetime(DatePlus(DateGet, -5));
  if IB_Query1.active then
    IB_Query1.Refresh
  else
    IB_Query1.Open;
end;

procedure TFormDruckSpooler.Button4Click(Sender: TObject);
begin
  with ListBox2 do
    if itemindex <> -1 then
      printhtmlok(MyProgramPath + cDruckauftragPath + items[itemindex]);
end;

procedure TFormDruckSpooler.Button5Click(Sender: TObject);
begin
  with ListBox2 do
    if itemindex <> -1 then
      openShell(MyProgramPath + cDruckauftragPath + items[itemindex]);
end;

procedure TFormDruckSpooler.Button6Click(Sender: TObject);
var
  n: integer;
begin
  BeginHourGlass;
  USerBreak := false;
  with ListBox2 do
  begin
    for n := 0 to pred(items.count) do
      if not(USerBreak) then
      begin
        itemindex := n;
        printhtmlok(MyProgramPath + cDruckauftragPath + items[n]);
        delay(4000);
      end;
  end;
  EndHourGlass;
end;

procedure TFormDruckSpooler.Log(const s: string);
begin
  ListBox1.items.Add(s);
  if pos('ERROR:', s) > 0 then
    CareTakerLog('DruckSpooler.' + s);
end;

procedure TFormDruckSpooler.refreshDruckauftraege;
var
  sPRN: TStringList;
begin
  sPRN := TStringList.create;
  with ListBox2 do
  begin
    items.BeginUpdate;
    items.clear;
    dir(MyProgramPath + cDruckauftragPath + '*' + cHTMLextension, sPRN, false);
    sPRN.sort;
    Label3.Caption := inttostr(sPRN.count);
    items.addstrings(sPRN);
    items.EndUpdate;
  end;
  sPRN.free;
end;

procedure TFormDruckSpooler.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormDruckSpooler.SpeedButton12Click(Sender: TObject);
begin
  refreshDruckauftraege;
end;

procedure TFormDruckSpooler.SpeedButton1Click(Sender: TObject);
begin
  with ListBox2 do
  begin

    if (itemindex <> -1) then
      if doit(items[itemindex] + ' wirklich löschen') then
      begin
        FileDelete(MyProgramPath + cDruckauftragPath + items[itemindex]);
        items.delete(itemindex);
      end;
  end;
end;

procedure TFormDruckSpooler.SpeedButton2Click(Sender: TObject);
var
  DSQL: TIB_DSQL;
  ActionDone: boolean;
begin
  ActionDone := false;
  if IB_Query1.active then
    if IB_Query1.FieldByName('GEDRUCKT').IsNull then
    begin
      DSQL := DataModuleDatenbank.nDSQL;
      with DSQL do
      begin
        sql.Add('update WARENBEWEGUNG set GEDRUCKT = :CROSSREF where RID=' +
            inttostr(IB_Query1.FieldByName('RID').AsInteger));
        parambyname('CROSSREF').AsDate := Date;
        execute;
      end;
      DSQL.free;
      IB_Query1.Refresh;
      ActionDone := true;
    end;
  if not(ActionDone) then
    beep;
end;

procedure TFormDruckSpooler.SpeedButton4Click(Sender: TObject);
var
  ActionDone: boolean;
begin
  ActionDone := false;
  if IB_Query1.active then
    if IB_Query1.FieldByName('GEDRUCKT').IsNotNull then
    begin
      e_x_sql(
        'update WARENBEWEGUNG set GEDRUCKT = NULL where RID=' + inttostr
          (IB_Query1.FieldByName('RID').AsInteger));
      IB_Query1.Refresh;
      ActionDone := true;
    end;
  if not(ActionDone) then
    beep;
end;

procedure TFormDruckSpooler.SpeedButton8Click(Sender: TObject);
begin
  openShell(MyProgramPath + cDruckauftragPath);
end;

procedure TFormDruckSpooler.Button7Click(Sender: TObject);
begin
  with IB_Query1 do
    if FieldByName('ARTIKEL_R').IsNotNull then
      FormArtikel.SetContext(FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormDruckSpooler.Button8Click(Sender: TObject);
begin
  FormWarenbewegung.SetContextArtikel(IB_Query1.FieldByName('ARTIKEL_R')
      .AsInteger);
end;

procedure TFormDruckSpooler.Button9Click(Sender: TObject);
begin
  USerBreak := true;
end;

end.
