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
unit Replikation;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, IB_Access, IB_Controls, Grids,
  IB_Grid, IB_UpdateBar, IB_NavigationBar,
  IB_Components, ExtCtrls, 
  IB_Session, ComCtrls, IB_Process,
  IB_Script, JvGIF;

type
  TFormReplikation = class(TForm)
    Button3: TButton;
    Button1: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Image3: TImage;
    IB_UpdateBar1: TIB_UpdateBar;
    Label4: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Label5: TLabel;
    Edit3: TEdit;
    Button4: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ErrorCount: integer;
    Transactions: integer;
    BreakRequest: boolean;
    procedure log(s: string);
    procedure BeginTransaction;
    procedure EndTransaction;
    procedure ExecuteOne;
  public
    { Public-Deklarationen }
    procedure Execute;
  end;

var
  FormReplikation: TFormReplikation;

implementation

uses
  anfix32, globals, IniFiles,
  BaseUpdate, Einstellungen, CareTakerClient,
  WordIndex, IBExportTable, Datenbank,
  Funktionen.Basis, wanfix32;

{$R *.dfm}

procedure TFormReplikation.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormReplikation.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Replikation');
end;

procedure TFormReplikation.Button1Click(Sender: TObject);
begin
  if (transactions = 0) then
    ExecuteOne
  else
    BreakRequest := true;
end;

procedure TFormReplikation.Button2Click(Sender: TObject);
var
  sBELEG: TSearchStringList;
  sPERSON: TStringList;
  sDIR: TStringList;
  n,m : integer;
  PERSON_R,PERSON_R_NEU: integer;
  BELEG_R,BELEG_R_NEU: integer;
  k: integer;
  StartTime : dword;

  procedure PlainCopy;
  begin
    CheckCreateDir(MyProgramPath+cRechnungPath+RIDasStr(PERSON_R_NEU));
    FileCopy(
      Edit2.Text+cRechnungPath+RIDasStr(PERSON_R)+'\'+sDir[m],
      MyProgramPath+cRechnungPath+RIDasStr(PERSON_R_NEU)+'\'+sDir[m]);
  end;

begin
  BeginHourGlass;
  //
  sBELEG:= TSearchStringList.create;
  sPERSON:= TStringList.create;
  sDIR:= TStringList.create;

  sBELEG.LoadFromFile(MyProgramPath+cTransitionPath+'BELEG.csv');
  sPERSON.LoadFromFile(MyProgramPath+cTransitionPath+'PERSON.csv');

  progressbar1.Max := sPerson.count;
  StartTime := 0;

  for n := 0 to pred(sPERSON.count) do
  begin
    PERSON_R := strtointdef(nextp(sPERSON[n],';',0),cRID_Null);
    if (PERSON_R>=cRID_FirstValid) then
      if DirExists(Edit2.Text+cRechnungPath+RIDasStr(PERSON_R)) then
      begin
        PERSON_R_NEU := strtointdef(nextp(sPERSON[n],';',1),cRID_Null);
        sDir.clear;
        dir(Edit2.Text+cRechnungPath+RIDasStr(PERSON_R)+'\*',sDir,false);
        for m := 0 to pred(sDir.count) do
        begin
          BELEG_R := strtointdef(nextp(sDir[m],'-',0),cRID_Null);
          if (BELEG_R>=cRID_FirstValid) then
          begin
            k := sBELEG.FindInc(inttostr(BELEG_R)+';');
            if (k<>-1) then
            begin
              BELEG_R_NEU := strtointdef(nextp(sBELEG[k],';',1),cRID_Null);
              if BELEG_R_NEU>=cRID_FirstValid then
              begin
                CheckCreateDir(MyProgramPath+cRechnungPath+RIDasStr(PERSON_R_NEU));
                FileCopy(
                  Edit2.Text+cRechnungPath+RIDasStr(PERSON_R)+'\'+sDir[m],
                  MyProgramPath+cRechnungPath+RIDasStr(PERSON_R_NEU)+'\'+
                  RIDasStr(BELEG_R_NEU)+
                  '-'+
                  nextp(sDir[m],'-',1));
              end;
            end else
            begin
              PlainCopy;
            end;
          end else
          begin
            // einfach nur so kopieren!
            PlainCopy;
          end;
        end;
      end;
    if frequently(StartTime, 333) or eof then
    begin
      application.processmessages;
      progressbar1.position := N;
    end;
  end;

  sBELEG.free;
  sPERSON.free;
  sDIR.free;
  EndHourGlass;
end;

procedure TFormReplikation.Execute;
begin
  show;
  Button3Click(self);
  close;
end;

procedure TFormReplikation.Button3Click(Sender: TObject);
begin
  BeginHourGlass;
  BeginTransaction;
  with IB_Query1 do
  begin
    first;
    while not (eof) do
    begin
      application.processmessages;
      if (FieldByName('INAKTIV').AsString <> cC_False) then
        ExecuteOne;
      if BreakRequest then
        break;
      next;
    end;
  end;
  EndTransaction;
  EndHourGlass;
end;

procedure TFormReplikation.Button4Click(Sender: TObject);
var
  sDOKUMENTE: TStringList;
  n: integer;
  DOKUMENT_R: integer;
  DOKUMENT_R_NEU: integer;

  procedure MoveIt(Fname: string);
  begin
    if FileExists(edit2.Text+Fname) then
    begin
      FileCopy(
        edit2.Text+
        Fname,
        edit3.Text+
        inttostrN(DOKUMENT_R_NEU,8)+
        StrFilter(FName,'0123456789',true));
    end;
  end;

begin
  sDOKUMENTE:= TStringList.create;
  sDOKUMENTE.LoadFromFile(MyProgramPath+cTransitionPath+'DOKUMENT.csv');
  for n := 0 to pred(sDOKUMENTE.count) do
  begin
    DOKUMENT_R := strtointdef(nextp(sDOKUMENTE[n],';',0),cRID_Null);
    DOKUMENT_R_NEU := strtointdef(nextp(sDOKUMENTE[n],';',1),cRID_Null);
    if (DOKUMENT_R>=cRID_FirstValid) and (DOKUMENT_R_NEU>=cRID_FirstValid) then
    begin
      MoveIt(inttostrN(DOKUMENT_R,8)+'.jpg');
      MoveIt(inttostrN(DOKUMENT_R,8)+'th.jpg');
    end;
  end;
  sDOKUMENTE.free;
end;

procedure TFormReplikation.log(s: string);
begin
  memo1.lines.add(s);
  if (pos(cERRORText, s) = 1) then
  begin
    inc(ErrorCount);
    CareTakerLog(s);
  end;
  if (ErrorCount > 0) then
    Label2.caption := inttostr(ErrorCount) + ' Fehler bisher!';
end;

procedure TFormReplikation.ExecuteOne;

const
  cSectionReplication = 'Replikation';

var
  ParamBlock: TStringList;
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  rINI: TMemIniFile;
  ActionStr: string;

  function OpenConnection: boolean;
  begin
    try
      rCONNECTION.Connect;
      result := true;
    except
      result := false;
    end;
  end;

  function CheckCompatibility: boolean;
  var
    tREVISION: TIB_Cursor;
    RemoteRev: single;
  begin
    tREVISION := DataModuleDatenbank.nCursor;
    with tREVISION do
    begin
      IB_Connection := rCONNECTION;
      sql.add('SELECT RID FROM REVISION ORDER BY RID DESCENDING');
      open;
      ApiFirst;
      RemoteRev := FieldByName('RID').AsInteger / 1000;
      close;
    end;
    tREVISION.free;
    result := round(RemoteRev * 1000.0) = round(FormBaseUpdate.BaseRev * 1000.0);
  end;

  procedure Replicate;
  var
    cQUELLE: TIB_Cursor;
    qZIEL: TIB_Query;
    sINDEX: TIB_Script;
    excludeFields: TStringList;
    includeFields: TStringList;
    insertFields: TstringList;
    deactiveIndexes: TStringList;
    Umfang: string;
    StartTime: dword;
    RecN: integer;
    TableName: string;
    AllFields: string;
    n: integer;
  begin
    BeginHourGlass;
    insertFields := TStringList.create;
    excludeFields := TStringList.create;
    includeFields := TStringList.create;
    deactiveIndexes := TStringList.Create;
    sINDEX := TIB_Script.create(self);

    // Indizes deaktivieren!
    AllFields := AnsiUpperCase(noblank(rIni.ReadString(cSectionReplication, 'Indizes', '')));
    while (AllFields <> '') do
      deactiveIndexes.add(nextp(AllFields, ','));

    if (deactiveIndexes.count > 0) then
    begin
      with sINDEX do
      begin
        for n := 0 to pred(deactiveIndexes.count) do
        begin
          sql.clear;
          sql.add('alter index ' + deactiveIndexes[n] + ' inactive;');
          execute;
        end;
      end;
    end;

    // Bestimmen der Felder, die nur im falle des insert hinzugenommen werden sollen
    AllFields := AnsiUpperCase('RID,' + noblank(rIni.ReadString(cSectionReplication, 'NurBeiInsert', '')));
    while (AllFields <> '') do
      insertFields.add(nextp(AllFields, ','));

    // Bestmmen der Felder, die ausgelassen werden sollen
    AllFields := AnsiUpperCase(noblank(rIni.ReadString(cSectionReplication, 'OhneDieFelder', '')));
    while (AllFields <> '') do
      excludeFields.add(nextp(AllFields, ','));

    TableName := rINI.ReadString(cSectionReplication, 'Tabelle', '');
    StartTime := 0;
    RecN := 0;

    qZIEL := DataModuleDatenbank.nQuery;
    with qZIEL do
    begin
      sql.add('SELECT * FROM ' + TableName);
      sql.add('WHERE RID=:CROSSREF');
      sql.Add('FOR UPDATE');
    end;

    cQUELLE := DataModuleDatenbank.nCursor;
    with cQUELLE do
    begin
      IB_Connection := rCONNECTION;
      sql.add('SELECT * FROM ' + TableName);
      umfang := rIni.ReadString(cSectionReplication, 'Umfang', '');
      if (umfang <> '') then
      begin
        sql.add('where');
        sql.add(umfang);
      end;
      open;
      Progressbar1.Max := RecordCount;
      APIFirst;
      if not (eof) then
      begin
        // prepare the fieldname list
        for n := 0 to pred(FieldCount) do
          if excludefields.indexof(AnsiUpperCase(Fields[n].fieldName)) = -1 then
            includeFields.add(Fields[n].fieldName);
      end;

      while not (eof) do
      begin
        QZiel.ParamByName('CROSSREF').Assign(FieldByName('RID'));
        if not (QZiel.Active) then
          QZiel.open;
        try
          if not (QZiel.Eof) then
          begin
            ActionStr := 'e';
            QZiel.edit;
            for n := 0 to pred(IncludeFields.count) do
              QZiel.FieldByName(IncludeFields[n]).assign(FieldByName(IncludeFields[n]));
            QZiel.Post;
          end else
          begin
            ActionStr := 'i';
            QZiel.insert;
            for n := 0 to pred(InsertFields.count) do
              QZiel.FieldByName(InsertFields[n]).assign(FieldByName(InsertFields[n]));
            for n := 0 to pred(IncludeFields.count) do
              QZiel.FieldByName(IncludeFields[n]).assign(FieldByName(IncludeFields[n]));
            QZiel.Post;
          end;
          inc(RecN);
        except
          on e: exception do
          begin
            Log(cERRORText + ' ' +
              ActionStr +
              '[' + FieldByName('RID').AsString + ']' +
              e.message);
            QZiel.cancel;
            QZiel.close;
          end;
        end;
        if BreakRequest then
          break;
        APINext;
        if frequently(StartTime, 333) or eof then
        begin
          application.processmessages;
          progressbar1.position := RecN;
        end;
      end;
      close;
    end;

    if (deactiveIndexes.count > 0) then
    begin
      with sINDEX do
      begin
        for n := 0 to pred(deactiveIndexes.count) do
        begin
          sql.clear;
          sql.add('alter index ' + deactiveIndexes[n] + ' active;');
          try
            execute;
          except
         // kann passieren!
          end;
        end;
      end;
    end;

    sINDEX.free;
    qZIEL.Close;
    qZIEL.Free;
    cQUELLE.Close;
    cQUELLE.Free;
    excludeFields.free;
    includeFields.free;
    insertFields.Free;
    deactiveIndexes.Free;
    progressbar1.position := 0;
    EndHourGlass;
  end;

  procedure Transit;

  type
    TReference = Int64;
  var
    iniF : TIniFile;

    // tools
    function rGEN(sTable:string):string;
    begin
      result := iniF.ReadString(sTable,'Generator','GEN_'+sTable);
    end;

    // rREF, liefert normierten Bezeichner "Tabelle"_R für eine Referenz
    // oder '', wenn es gar kein Referenzfeld ist.
    function rREF(sTable:string;sField:string):string;
    begin
      result := '';
      if (revpos('_R',sField)=length(sField)-1) then
      begin
        result := iniF.ReadString(sTable,sField,sField);
        if (result=cOLAPnull) then
          result := '';
      end;
    end;

    function rTAB(sReference:string):string;
    begin
      result := nextp(sReference,'_R',0);
    end;

    function rFName(sTable:string) : string;
    begin
      result := MyProgramPath+cTransitionPath+sTable+'.csv';
    end;

    function get(sTable:string;ALT:TReference):TReference; forward;

    procedure oneTable(TableName:string);
    var
      cQUELLE: TIB_Cursor;
      qZIEL: TIB_Query;
      Umfang: string;
      ALT,NEU,REF: TReference;
      sTransitions: TSearchStringList;
      n: integer;
      sField,sReference: string;
      RecN,RecC: integer;
      StartTime : dword;
    begin
      Memo1.lines.add(TableName);
      application.processmessages;

      sTransitions:= TSearchStringList.create;
      if FileExists(rFName(TableName)) then
        sTransitions.LoadFromFile(rFName(TableName));

      qZIEL := DataModuleDatenbank.nQuery;
      with qZIEL do
      begin
        sql.add('SELECT * FROM ' + TableName);
        sql.add('WHERE RID=:CROSSREF');
        sql.Add('FOR UPDATE');
      end;

      cQUELLE := DataModuleDatenbank.nCursor;
      with cQUELLE do
      begin
        IB_Connection := rCONNECTION;
        sql.add('SELECT * FROM ' + TableName);
        umfang := rIni.ReadString(cSectionReplication, 'Umfang', '');
        if (umfang <> '') then
        begin
          sql.add('where');
          sql.add(umfang);
        end;
        open;
        RecC := RecordCount;
        RecN := 0;
        StartTime :=0;
        APIFirst;

        while not (eof) do
        begin
          ALT := FieldByName('RID').AsInt64;
          if (sTransitions.FindInc(inttostr(ALT)+';')=-1) then
          begin
            // Neuanlage!
            NEU := QZiel.GEN_ID(rGEN(TableName),1);
            QZiel.insert;
            QZiel.FieldByName('RID').AsInt64 := NEU;

            for n := 0 to pred(FieldCount) do
            begin
              sField := Fields[n].fieldName;
              if (sField='RID') then
                continue;
              if FieldByName(sField).IsNotNull then // was drin!
              begin
                sReference := rREF(TableName,sField);
                if (sReference<>'') then // ein echter Referenzwert
                begin
                  // lese alte Referenz
                  REF := FieldByName(sField).AsInt64;
                  // speichere neue Referenz
                  QZiel.FieldByName(sField).AsInt64 := get(rTAB(sReference),REF);
                end else
                begin
                  QZiel.FieldByName(sField).assign(FieldByName(sField));
                end;
              end;

            end;

            QZiel.Post;

            sTransitions.add(inttostr(ALT)+';'+inttostr(NEU));
            sTransitions.SaveToFile(rFName(TableName));
          end;

          if BreakRequest then
            break;
          APINext;
          if frequently(StartTime, 333) or eof then
          begin
            // wegen Rekursion muss auch Max wieder neu gesetzt werden!
            Progressbar1.Max := RecC;
            progressbar1.position := RecN;
            application.processmessages;
          end;
          inc(RecN);

        end;
        close;
      end;
      progressbar1.position := 0;
    end;

    function get(sTable:string;ALT:TReference):TReference;
    var
      sTransitions: TSearchStringList;
      k : integer;
    begin
      result := cRID_Null;
      sTransitions:= TSearchStringList.create;
      if FileExists(rFName(sTable)) then
        sTransitions.LoadFromFile(rFName(sTable));
      k := sTransitions.FindInc(inttostr(ALT)+';');
      if (k<>-1) then
      begin
        result := strtoint(nextp(sTransitions[k],';',1));
      end else
      begin
        oneTable(sTable);
        result := get(sTable,ALT);
      end;
      sTransitions.free;
    end;

  begin
    iniF := TIniFile.create(MyProgramPath+cTransitionPath+'Transition.ini');
    OneTable(rIni.ReadString(cSectionReplication, 'Tabelle', ''));
    iniF.free;
  end;

begin
  BeginTransaction;

  // Parameter übernehmen in einen "iniFile"
  ParamBlock := TStringList.create;
  IB_Query1.FieldByName('SCRIPT').AssignTo(ParamBlock);

  ParamBlock.Insert(0, '[' + cSectionReplication + ']');

  rINI := TMemIniFile.create('');
  rINI.SetStrings(ParamBlock);
  ParamBlock.free;

  // Verbindung aufbauen (connect)
  rTRANSACTION := TIB_Transaction.Create(self);
  with rTRANSACTION do
  begin
    Isolation := tiCommitted;
    AutoCommit := true;
    ReadOnly := True;
  end;

  rCONNECTION := TIB_Connection.Create(self);
  with rCONNECTION do
  begin
    DefaultTransaction := rTRANSACTION;
    LoginDBReadOnly := true;
    Protocol := cpTCP_IP;
    if (edit1.text = '') then
      DataBaseName := rINI.ReadString(cSectionReplication, 'DataBaseName', '')
    else
      DataBaseName := edit1.text;

    UserName := 'SYSDBA';
    Password := deCrypt_Hex(iDataBase_SYSDBA_pwd);
  end;

  with rTRANSACTION do
  begin
    IB_Connection := rCONNECTION;
  end;

  while true do
  begin

    // Verbinung
    if not (OpenConnection) then
    begin
      Log(cERRORText + ' ' + 'Quelldatenbank konnte nicht geöffnet werden!');
      break;
    end;

    // Datenbank Kompatibilität sicherstellen
    if not (CheckCompatibility) then
    begin
      Log(cERRORText + ' ' + 'Die in DataBaseName= angegebene Datenbank' + #13 +
        'muss upgedatet werden. Bitte starten Sie ' + cApplicationName + #13 +
        'mit dieser Datenbank, damit die neueste Rev.' + #13 +
        'eingetragen werden kann!');
      break;
    end;

    // Replikationslauf an sich
    if (rINI.ReadString(cSectionReplication, 'Mode', '')='Transition') then
      Transit
    else
      Replicate;
    break;

  end;


  //
  rINI.free;

  rTRANSACTION.free;
  rConnection.Close;
  rCONNECTION.free;

  EndTransaction;

end;

procedure TFormReplikation.BeginTransaction;
begin
  if (Transactions = 0) then
  begin
    memo1.lines.clear;
    ErrorCount := 0;
    label2.caption := 'Ausführungsfehler';
    button3.enabled := false;
    button1.caption := 'Ab&brechen';
  end;
  inc(Transactions);
end;

procedure TFormReplikation.EndTransaction;
begin
  dec(Transactions);
  if (Transactions = 0) then
  begin
    button1.caption := 'Ausführen';
    button3.enabled := true;
    BreakRequest := false;
  end;
end;

end.

