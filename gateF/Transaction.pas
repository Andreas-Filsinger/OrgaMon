unit Transaction;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls;

const
  VersionTransaction: single = 1.003; // G:\rev\Transaction.rev
  cUnchangedFlag = '~'; // !Unchanged-Flag!
  cFNamePrefix = 'Anfrage Pforte ';
  cFNameSuffix = '.txt';
  cSleepGranularity = 35; // [ms]
  cSleepTimeOut = 1000; // [ms]

type
  eModificationType = (MF_New, MF_Change, MF_Delete);

type
  TFormTransaction = class(TForm)
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Label6: TLabel;
    StaticText6: TStaticText;
    Panel1: TPanel;
    Button1: TButton;
    Label7: TLabel;
    StaticText7: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FirstTransactionDone: boolean;
  public
    { Public-Deklarationen }
    Delimiter: string; // wie sind die Daten getrennt
    IDColumn: integer; // wo ist die Spalte mit den Daten
    SortColumn: integer; // wo ist die Spalte mit dem Sortier-String
    MainListFName: string; // wie heißt die Ausgabe-Datei
    TrnWarningCount: integer; //

    // Statistik
    TC_New: integer;
    TC_Change: integer;
    TC_Delete: integer;
    TT_OverAll: int64;
    TC_Exception: integer;
    TC_ShowCountNow: boolean;

    procedure StoreTransaktion(ModificationType: eModificationType; OldDataS, NewDataS: string); overload;
    procedure StoreTransaktion(ModificationType: eModificationType; NewDataS: string); overload;

    function ModificationToStr(ModificationType: eModificationType): string;
    function TrnFName: string;
  end;

var
  FormTransaction: TFormTransaction;

implementation

uses
  globals, anfix32, wanfix32;

{$R *.DFM}

procedure TFormTransaction.StoreTransaktion(ModificationType: eModificationType; OldDataS, NewDataS: string);
var
  OutF: TextFile;
  DiffData: string;
  FieldCounter: integer;
  _OldValue: string;
  _NewValue: string;
  SleptByNow: integer;

begin
  if (ModificationType = MF_Change) then
  begin
    //
    DiffData := '';
    FieldCounter := 0;
    while (NewDataS <> '') do
    begin
      inc(FieldCounter);
      if (FieldCounter = IDColumn) then
      begin
        nextp(OldDataS, Delimiter);
        DiffData := DiffData + nextp(NewDataS, Delimiter) + Delimiter;
      end else
      begin
        _OldValue := nextp(OldDataS, Delimiter);
        _NewValue := nextp(NewDataS, Delimiter);
        if (_OldValue <> _NewValue) then
          DiffData := DiffData + _NewValue + Delimiter
        else
          DiffData := DiffData + cUnchangedFlag + Delimiter;
      end;
    end;
    DiffData := ModificationToStr(ModificationType) + Delimiter + DiffData;
  end else
  begin
    DiffData := ModificationToStr(ModificationType) + Delimiter + NewDataS;
  end;

  if FileExists(TrnFName) then
  begin
    SleptByNow := 0;
    while ((FileGetAttr(TrnFName) and faReadOnly) = faReadOnly) do
    begin
      sleep(cSleepGranularity);
      inc(SleptByNow, cSleepGranularity);
      if (SleptByNow >= cSleepTimeOut) then
      begin
        FileSetAttr(TrnFName, 0);
        break;
      end;
    end;
  end;

  ioresult;
  AssignFile(OutF, TrnFName);
{$I-}
  append(OutF);
{$I+}
  if (ioresult <> 0) then
    rewrite(OutF);
  writeln(OutF, DiffData);
  CloseFile(OutF);
end;

procedure TFormTransaction.StoreTransaktion(ModificationType: eModificationType; NewDataS: string);
begin
  StoreTransaktion(ModificationType, '', NewDataS);
end;

function TFormTransaction.ModificationToStr(ModificationType: eModificationType): string;
begin
  case ModificationType of
    MF_New: result := '+';
    MF_Change: result := '*';
    MF_Delete: result := '-';
  end;
end;

procedure TFormTransaction.FormCreate(Sender: TObject);
begin
  Delimiter := ';';
  IDColumn := 16;
  MainListFName := MyProgramPath + cListeFName;
end;

function TFormTransaction.TrnFName: string;
begin
  result := MyProgramPath + cTransactionPath + cFNamePrefix + inttostr(iPforteID) + cFNameSuffix;
end;

procedure TFormTransaction.Timer1Timer(Sender: TObject);
var
  FilesToProcess: TStringList;
  TransActionFName: string;
  TransActionData: TStringList;
  AllTheData: TStringList;
  IndexedKeys: TStringList;
  CompletedTransAktions: TStringList;
  n, m: integer;
  ActTRAN: string;
  BeforeTRAN: string;
  AfterTRAN: string;
  TRANType: string;
  TRANid: string;
  FoundLine: integer;
  _NewData: string;
  ChangedRowCount: integer;
  _TT_OverAll: int64;
  ShouldRecreate: boolean;
  _TrnDiagFName: string;
  _MainListFName: string;

  procedure TransaktionWarning(OutMsg: string);
  begin
    inc(TrnWarningCount);
    CompletedTransAktions.add('w' + Delimiter + OutMsg);
  end;

  procedure CreateTheIndex;
  var
    DupCount, n: integer;
    Dups: TStringList;
  begin
    IndexedKeys.clear;
    for n := 0 to pred(AllTheData.count) do
      IndexedKeys.addObject(nextp(AllTheData[n], Delimiter, pred(IDColumn)), TObject(n));
    IndexedKeys.sort;
    Dups := TStringList.create;
    RemoveDuplicates(IndexedKeys, DupCount, Dups);
    for n := 0 to pred(DupCount) do
      TransaktionWarning('Identifikationsprobleme durch doppelten Index Wert ' + Dups[n]);
    Dups.free;
    ShouldRecreate := false;
  end;

  function SearchForID(TheID: string): integer;
  begin
    result := IndexedKeys.indexof(TRANid);
    if (result <> -1) then
      result := integer(IndexedKeys.objects[result]);
  end;

begin

 // Transaktion Processing!
  if iTransactionServer then
  begin
    iTransactionServer := false;

    try

      FilesToProcess := TStringList.Create;
      dir(MyProgrampath + cTransactionPath + cFNamePrefix + '*' + cFNameSuffix, FilesToProcess, false);
      if (FilesToProcess.count > 0) then
      begin

        AllTheData := TStringList.create;
        IndexedKeys := TStringList.create;
        TransActionData := TStringList.create;
        CompletedTransAktions := TStringList.create;
        ShouldRecreate := true;
        _TT_OverAll := RDTSCms;
        _TrnDiagFName := MyProgramPath + cDiagnosePath + 'Transaktionen ' + inttoStrN(DateGet, 8) + '.txt';

        FileSetAttr(MainListFName, 0);
        AllTheData.LoadFromFile(MainListFName);

        if not (FileExists(_TrnDiagFName)) then
          AllTheData.SaveToFile(_TrnDiagFName);

        for n := 0 to pred(FilesToProcess.count) do
        begin

     // Namen der Datei bestimmen!
          TransActionFName := MyProgramPath + cTransactionPath + FilesToProcess[n];
          CompletedTransAktions.Add('i' + delimiter + secondstostr(secondsget) + delimiter + FilesToProcess[n]);

     // Lesen  & Löschung
     { -- begin critical Section }
          FileSetAttr(TransActionFName, faReadOnly);
          TransActionData.LoadFromFile(TransActionFName);
          FileDelete(TransActionFName);
     { -- end critical Section }

     // Verarbeitung
          for m := 0 to pred(TransActionData.count) do
          begin

      // should i sort?!
            if ShouldRecreate then
              CreateTheIndex;

            ActTRAN := TransActionData[m];
            TRANType := nextp(ActTRAN, Delimiter);
            TRANid := nextp(ActTRAN, Delimiter, pred(IDColumn));
            FoundLine := SearchForID(TRANid);

            case TRANType[1] of
              '+': begin // new
                  if (FoundLine = -1) then
                  begin
                    inc(TC_New);
                    AllTheData.add(ActTRAN);
                    ShouldRecreate := true;
                  end else
                  begin
                    TransaktionWarning('Datensatz ' + TRANid + ' schon vorhanden');
                  end;
                end;
              '*': begin // change
                  if (FoundLine <> -1) then
                  begin
                    inc(TC_Change);
                    ChangedRowCount := 0;
                    BeforeTRAN := AllTheData[FoundLine]; // unchanged Data
                    AfterTRAN := ''; // the new Data
                    while (ActTRAN <> '') do
                    begin
                      _NewData := nextp(ActTRAN, Delimiter);
                      if (_NewData = cUnchangedFlag) then
                      begin
                        AfterTRAN := AfterTRAN + nextp(BeforeTRAN, Delimiter) + Delimiter;
                      end else
                      begin
                        if (nextp(BeforeTRAN, Delimiter) <> _NewData) then
                          inc(ChangedRowCount);
                        AfterTRAN := AfterTRAN + _NewData + Delimiter;
                      end;
                    end;
                    AllTheData[FoundLine] := AfterTRAN;
                    if (ChangedRowCount = 0) then
                    begin
                      TransaktionWarning('Am Datensatz ' + TRANid + ' wurden keine Änderungen vorgenommen');
                    end;
                  end else
                  begin
                    TransaktionWarning('Datensatz ' + TRANid + ' zum Modifizieren nicht mehr gefunden');
                  end;
                end;
              '-': begin // delete
                  if (FoundLine <> -1) then
                  begin
                    inc(TC_Delete);
                    AllTheData.delete(FoundLine);
                    ShouldRecreate := true;
                  end else
                  begin
                    TransaktionWarning('Datensatz ' + TRANid + ' zum Löschen nicht mehr gefunden');
                  end;
                end;
            end;
          end;
          CompletedTransAktions.AddStrings(TransActionData);
        end;

        // Ausgabe der neuen Daten
        repeat
          _MainListFName := MainListFName;
          ersetze('.ini', '.$$$', _MainListFName);
          AllTheData.SaveToFile(_MainListFName);

          FileDelete(MainListFName);
          RenameFile(_MainListFName, MainListFName);

          if (AllTheData.count > 0) then
            if (FSize(MainListFName) = 0) then
            begin
              TransaktionWarning('Speichern musste wiederholt werden!');
              continue;
            end;

        until true;

        // Wieder freigeben!
        FileSetAttr(MainListFName, faReadOnly);

        // Statistik
        inc(TT_OverAll, RDTSCms - _TT_OverAll);

        // Ausgabe zur Diagnose
        if not (FirstTransactionDone) then
        begin
          FirstTransactionDone := true;
          CompletedTransAktions.insert(0, 'i' + delimiter + secondstostr(secondsget) + delimiter + 'startup of Transaction Server Rev. ' + RevToStr(VersionTransaction));
        end;
        AppendStringsToFile(CompletedTransAktions, _TrnDiagFName);

        // Speicher freigeben
        AllTheData.free;
        IndexedKeys.free;
        TransActionData.free;
        CompletedTransAktions.free;
      end else
      begin

        // Screen Update if idle
        if active then
        begin
          if TC_ShowCountNow then
            StaticText1.Color := StaticText2.Color
          else
            StaticText1.Color := clLime;

          StaticText1.caption := inttostrN(TC_New + TC_Change + TC_Delete, 5);
          TC_ShowCountNow := not (TC_ShowCountNow);

          StaticText2.caption := inttostrN(TC_New, 5);
          StaticText3.caption := inttostrN(TC_Change, 5);
          StaticText4.caption := inttostrN(TC_Delete, 5);
          StaticText5.caption := inttostrN(TrnWarningCount, 5);
          StaticText6.caption := inttostrN(TT_OverAll, 6) + ' ms';
          StaticText7.caption := inttostrN(TC_Exception, 5);
        end;

      end;

      FilesToProcess.free;
    except
      inc(TC_Exception);
      iTransactionServer := true;
    end;
    iTransactionServer := true;
  end;
end;

procedure TFormTransaction.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
    close;
end;

procedure TFormTransaction.Button2Click(Sender: TObject);
begin
  if FileExists(MyProgramPath + cDiagnosePath + 'Transaktionen ' + inttoStrN(DateGet, 8) + '.txt') then
    openShell(MyProgramPath + cDiagnosePath + 'Transaktionen ' + inttoStrN(DateGet, 8) + '.txt')
  else
    ShowMessage('Heute wurden noch keine Transaktionen durchgeführt!');
end;

procedure TFormTransaction.Button1Click(Sender: TObject);
var
  AllTrns: TStringList;
  ListeIni: TStringList;
  NewTrns: TStringList;
  n: integer;
begin
 // RePlay
  if not (iTransactionServer) then
  begin
    ShowMessage('Nur auf dem Transaktions-Server möglich!');
    exit;
  end;

  if not (FileExists(MyProgramPath + cDiagnosePath + 'Transaktionen ' + inttoStrN(DateGet, 8) + '.txt')) then
  begin
    ShowMessage('Heute wurden noch keine Transaktionen durchgeführt!');
    exit;
  end;

  if doit('Dies zwingt den Server alle' + #13 +
    'Transaktionen des Tages nochmals durchzuführen' + #13 +
    'diese Aktion kann sehr lange dauern, und ist' + #13 +
    'im Regelfall nicht notwendig.' + #13 +
    #13 +
    'Jetzt starten') then
  begin
    n := 0;
    if iTransactionServer then
    begin
      FileSetAttr(MainListFName, 0);
      iTransactionServer := false;
      AllTrns := TStringList.create;
      ListeIni := TStringList.create;
      NewTrns := TStringList.create;

      AllTrns.LoadFromFile(MyProgramPath + cDiagnosePath + 'Transaktionen ' + inttoStrN(DateGet, 8) + '.txt');

      for n := 0 to pred(AllTrns.count) do
      begin
        case AllTrns[n][1] of
          '0'..'9': begin
              ListeIni.add(AllTrns[n]);
            end;
          '*', '+', '-': begin
              NewTrns.add(AllTrns[n]);
            end;
        end;
      end;
      ListeIni.SaveToFile(MainListFName);
      FileSetAttr(MainListFName, faReadOnly);
      NewTrns.SaveToFile(MyProgramPath + cTransactionPath + cFNamePrefix + '0' + cFNameSuffix);
      AllTrns.free;
      ListeIni.free;
      NewTrns.free;
      iTransactionServer := true;
    end;
    close;
  end;
end;

end.

