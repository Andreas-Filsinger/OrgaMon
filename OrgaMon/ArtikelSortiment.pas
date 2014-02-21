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
unit ArtikelSortiment;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  Grids,

  // IB-Objects
  IB_Access,
  IB_Components,
  IB_Grid,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,

  // HeBu-Project
  ComCtrls, StdCtrls,
  IB_Controls, JvGIF, Buttons;

type
  TFormArtikelSortiment = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    IB_Query5: TIB_Query;
    IB_Query6: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Button1: TButton;
    StaticText1: TStaticText;
    ProgressBar1: TProgressBar;
    TabSheet2: TTabSheet;
    ProgressBar2: TProgressBar;
    Button2: TButton;
    TabSheet3: TTabSheet;
    ProgressBar3: TProgressBar;
    Button3: TButton;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    IB_Query7: TIB_Query;
    StaticText6: TStaticText;
    TabSheet4: TTabSheet;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button4: TButton;
    ProgressBar4: TProgressBar;
    Label4: TLabel;
    IB_Query8: TIB_Query;
    Button5: TButton;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    IB_Query9: TIB_Query;
    TabSheet5: TTabSheet;
    IB_Query10: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_ComboBox1: TIB_ComboBox;
    Label9: TLabel;
    TabSheet6: TTabSheet;
    Image2: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Button7: TButton;
    SpeedButton1: TSpeedButton;
    TabSheet7: TTabSheet;
    Edit2: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Button11: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IB_Query10BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure Image2Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private-Deklarationen }
    SortimentMwStCache: TStringList;
    LagerCache: TStringList;
    procedure EnsureCache;
    procedure Neu;
    procedure mShow;
  public
    { Public-Deklarationen }
    procedure CalcTheDiff;
    procedure DisableCache;
    procedure SortimentChange(SORTIMENT_R: integer; NETTO: boolean);
    procedure setContext(SORTIMENT_R:integer);
  end;

var
  FormArtikelSortiment: TFormArtikelSortiment;

implementation

uses
  globals, anfix32,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  ArtikelVerlag,
  Lager,  CareTakerClient,
  Artikel, Geld, Datenbank,
  dbOrgaMon, wanfix32;

{$R *.DFM}

procedure TFormArtikelSortiment.FormActivate(Sender: TObject);
var
  MWST: TIB_Cursor;
begin
  DateTimePicker1.date := long2datetime(date2long('01' + copy(long2date(DateGet), 3, MaxInt)));
  DateTimePicker2.date := now;
  if not (IB_query1.active) then
  begin
    MWST := DataModuleDatenbank.nCursor;
    with MWST, IB_ComboBox1 do
    begin
//      Items.Add(cRefComboOhneEintrag); nur im Fall, wenn NULL erlaubt ist!
//      Itemvalues.add(''); // NULL
      sql.add('select rid,satz from MWST order by satz');
      open;
      first;
      while not (eof) do
      begin
        Items.Add(format('%2.1f%%', [FieldByName('SATZ').AsDouble]));
        Itemvalues.add(FieldByName('RID').AsString);
        next;
      end;
      close;
    end;
    MWST.Free;

    IB_query1.open;
  end;
  if not (IB_query10.active) then
    IB_query10.open;
  CalcTheDiff;
end;

type
  TDouble = class(TObject)
    wert: double;
  end;

procedure TFormArtikelSortiment.Button11Click(Sender: TObject);
var
  Preis : double;
  Prozent: double;
  qARTIKEL : TIB_Query;
  SORTIMENT_R: integer;
begin
  // Prozentwert bestimmen
  Prozent := strtodoubledef(edit2.text,0.0);
  if (Prozent=0.0) then
   exit;

  Prozent := 100.0 + Prozent;

  // Preis-Änderung
  SORTIMENT_R:= IB_Query1.FieldByName('RID').AsInteger;
  if (SORTIMENT_R>=cRID_FirstValid) then
  begin
    BEginHourGlass;
    qARTIKEL := DataModuleDatenbank.nQuery;
    with qARTIKEL do
    begin
      sql.add(
        'select EURO from ARTIKEL where'+
        ' (EURO is not null) and'+
        ' (SORTIMENT_R='+inttostr(SORTIMENT_R)+') '+
        'for update');
      OPen;
      First;
      while not(eof) do
      begin
        edit;
        FieldByName('EURO').AsDouble := cPercent(Prozent,FieldByName('EURO').AsDouble);
        post;
        next;
      end;
      close;
    end;
    EndHourGlass;
  end;
  IB_Query1.Next;
end;

procedure TFormArtikelSortiment.Button1Click(Sender: TObject);
var
  StartTime: dword;
  RecRead: integer;
  KundeListe: TStringList;
  E_NoSortiment: integer;
  E_ArtikelNotFound: integer;
  W_ArtikelZero: integer;
  I_PostenLines: integer;
  I_OtherSortiment: integer;
begin
  IB_Query3.Open;
  IB_Query4.Open;
  IB_Query5.Open;
  KundeListe := TStringList.create;
  StartTime := 0;
  RecRead := 0;
  E_NoSortiment := 0;
  E_ArtikelNotFound := 0;
  W_ArtikelZero := 0;
  I_PostenLines := 0;
  I_OtherSortiment := 0;
  with IB_Query3 do
  begin
    progressbar1.position := 0;
    progressbar1.Max := RecordCount;
    first;
    while not (eof) do
    begin
      //
      IB_Query5.ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('RID').AsInteger;
      if not (IB_Query5.IsEmpty) then
      begin
        IB_Query5.first;
        while not (IB_Query5.Eof) do
        begin
          inc(I_PostenLines);
          if not (IB_Query5.FieldByName('ARTIKEL_R').IsNull) then
          begin
            IB_Query4.ParamByName('CROSSREF').AsInteger := IB_Query5.FieldByName('ARTIKEL_R').AsInteger;
            if not (IB_Query4.IsEmpty) then
            begin
              if not (IB_Query4.FieldByName('SORTIMENT_R').IsNull) then
              begin
                if IB_Query4.FieldByName('SORTIMENT_R').AsInteger = IB_Query1.FieldByName('RID').AsInteger then
                begin
                  KundeListe.add(inttostr(IB_Query3.FIeldByName('PERSON_R').AsInteger));
                end                else
                begin
                  inc(I_OtherSortiment);
                end;
              end              else
              begin
                inc(E_NoSortiment);
              end;
            end            else
            begin
              inc(E_ArtikelNotFound);
            end;
          end          else
          begin
            inc(W_ArtikelZero);
          end;
          IB_Query5.next;
        end;
      end;

      inc(RecRead);
      next;

      if eof or frequently(StartTime, 400) then
      begin
        progressbar1.position := RecRead;
        StaticText1.caption := inttostr(KundeListe.count);
        application.processmessages;
      end;

    end;
    progressbar1.position := 0;
    KundeListe.sort;
    RemoveDuplicates(KundeListe);
    ShowMessage('Effektive Kundenanzahl ist ' + inttostr(KundeListe.count) + #13 +
      #13 +
      'E_NoSortiment=' + inttostr(E_NoSortiment) + #13 +
      'E_ArtikelNotFound=' + inttostr(E_ArtikelNotFound) + #13 +
      'W_ArtikelZero=' + inttostr(W_ArtikelZero) + #13 +
      'I_PostenLines=' + inttostr(I_PostenLines) + #13 +
      'I_OtherSortiment=' + inttostr(I_OtherSortiment) + #13
      );
    KundeListe.Free;
  end;
end;

procedure TFormArtikelSortiment.Button2Click(Sender: TObject);
var
  StartTime: dword;
  AllData: TStringList;
  RecNom: integer;
  TheRid: integer;
  ArtikelInfo: TstringList;
begin
  screen.cursor := crHourglass;
  TheRid := IB_query1.FieldByName('RID').AsInteger;
  AllData := TStringList.create;
  ArtikelInfo := TStringList.create;
  StartTime := 0;
  RecNom := 0;
  with IB_QUERY6 do
  begin
    open;
    ParamByName('CROSSREF').AsInteger := TheRid;
    progressbar2.max := RecordCount;
    first;
    while not eof do
    begin
      FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);

      AllData.add(FieldByName('RID').AsString + ';' +
        FieldByName('NUMERO').AsString + ';' +
        NoSemi(FieldByName('TITEL').AsString) + ';' +
        NoSemi(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger)) + ';' +
        inttostr(FieldByName('MENGE').AsInteger) + ';' +
        NoSemi(ArtikelInfo.Values['BEM']) + ';' +
        e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger) + ';' +
        NoSemi(ArtikelInfo.Values['VERLAGNO']) + ';'
        );
      next;
      inc(RecNom);
      if frequently(StartTime, 400) or eof then
      begin
        application.processmessages;
        progressbar2.position := REcNom;
      end;
    end;
  end;
  progressbar2.position := 0;
  AllData.SaveToFile(DiagnosePath + 'Sortiment ' + inttostr(TheRid) + '.txt');
  screen.cursor := crdefault;
  ShowMessage(inttostr(AllData.count) + ' Datensätze unter' + #13 +
    DiagnosePath + 'Sortiment ' + inttostr(TheRid) + '.txt' + #13 +
    'abgelegt!');
  AllData.free;
  ArtikelInfo.free;
end;

procedure TFormArtikelSortiment.Button3Click(Sender: TObject);
var
  RecNom: integer;
  StartTime: dword;

  S_UmsatzSummeBrutto: double;
  S_UmsatzSummeNetto: double;
  S_UmsatzMenge: double;
  S_Rabatte: double;

  I_PostenLines: integer;
  I_OtherSortiment: integer;
  E_NoSortiment: integer;
  E_ArtikelNotFound: integer;
  W_ArtikelZero: integer;
  TheRid: integer;
  AllData: TStringList;

  _DieseMenge: double;
  _Rabatt: double;
  _PreisOhneRabatt: double;
  _Preis: double;

  FName: string;

begin
 //
  AllData := TStringList.create;
  TheRid := IB_Query1.FieldByName('RID').AsInteger;
  StartTime := 0;
  S_UmsatzSummeBrutto := 0.0;
  S_UmsatzSummeNetto := 0.0;
  S_UmsatzMenge := 0.0;
  S_Rabatte := 0.0;
  E_NoSortiment := 0;
  E_ArtikelNotFound := 0;
  W_ArtikelZero := 0;
  I_PostenLines := 0;
  I_OtherSortiment := 0;
  IB_Query5.Open;
  IB_Query4.Open;
  with IB_Query7 do
  begin
    if active then
      close;
    ParamByName('DATE1').AsDateTime := DateTimePicker1.Date;
    ParamByName('DATE2').AsDateTime := DateTimePicker2.Date;
    Open;
    progressbar3.Max := RecordCount;
    first;
    RecNom := 0;
    while not (eof) do
    begin
      IB_QUery5.ParamByName('CROSSREF').AsInteger := FieldByName('RID').AsInteger;
      if not (IB_Query5.IsEmpty) then
      begin
        IB_Query5.first;
        while not (IB_Query5.Eof) do
        begin
          inc(I_PostenLines);
          if not (IB_Query5.FieldByName('ARTIKEL_R').IsNull) then
          begin
            IB_Query4.ParamByName('CROSSREF').AsInteger := IB_Query5.FieldByName('ARTIKEL_R').AsInteger;
            if not (IB_Query4.IsEmpty) then
            begin
              if not (IB_Query4.FieldByName('SORTIMENT_R').IsNull) then
              begin
                if IB_Query4.FieldByName('SORTIMENT_R').AsInteger = TheRid then
                begin

                  // Mein Artikel!
                  _DieseMenge := IB_Query5.FieldByName('MENGE_GELIEFERT').AsInteger;
                  _Rabatt := IB_Query5.FieldByName('RABATT').AsDouble;
                  _PreisOhneRabatt := IB_Query5.FieldByName('PREIS').AsDouble * _DieseMenge;
                  if _Rabatt > 0 then
                  begin
                    _Preis := _PreisOhneRabatt - (_PreisOhneRabatt * (_Rabatt / 100.0));
                    _Preis := round(_Preis * 100.0) / 100.0;
                  end                  else
                  begin
                    _Preis := _PreisOhneRabatt;
                  end;

                  AllData.add({Nummer} inttostrN(IB_Query4.FieldByName('NUMERO').AsInteger, 8) + ';' +
                      {Bez} IB_Query4.FieldByName('TITEL').AsString + ';' +
                      {Komp}'' + ';' +
                      {Arran}'' + ';' +
                      {Menge} format('%.0f', [_DieseMenge]) + ';' +
                      {Preis} format('%.2f', [_PreisOhneRabatt]) + ';' +
                      {Rabatt} format('%.2f', [_Rabatt]) + ';' +
                      {Preis2} format('%.2f', [_Preis])
                    );

                  S_UmsatzSummeBrutto := S_UmsatzSummeBrutto + _PreisOhneRabatt;
                  S_UmsatzSummeNetto := S_UmsatzSummeNetto + _Preis;
                  S_UmsatzMenge := S_UmsatzMenge + _DieseMenge;
                  S_Rabatte := S_Rabatte + (_DieseMenge * _Rabatt);

                end                else
                begin
                  inc(I_OtherSortiment);
                end;
              end              else
              begin
                inc(E_NoSortiment);
              end;
            end            else
            begin
              inc(E_ArtikelNotFound);
            end;
          end          else
          begin
            inc(W_ArtikelZero);
          end;
          IB_Query5.next;
        end;
      end;

      next;
      inc(RecNom);
      if frequently(StartTime, 400) or eof then
      begin
        application.processmessages;
        progressbar3.position := RecNom;
        StaticText2.caption := format('Umsatz: %m', [S_UmsatzSummeBrutto]);
        StaticText3.caption := format('Menge: %.0f', [S_UmsatzMenge]);
        if S_UmsatzMenge <> 0 then
          StaticText4.caption := format('Rabatt: %.1f%%', [S_Rabatte / S_UmsatzMenge])
        else
          StaticText4.caption := format('Rabatt: %.1f%%', [0.0]);
        StaticText5.caption := format('echter Umsatz: %m', [S_UmsatzSummeNetto]);
      end;
    end;
    ShowMessage('BelegAnzahl ist ' + inttostr(RecordCount) + #13 +
      #13 +
      'E_NoSortiment=' + inttostr(E_NoSortiment) + #13 +
      'E_ArtikelNotFound=' + inttostr(E_ArtikelNotFound) + #13 +
      'W_ArtikelZero=' + inttostr(W_ArtikelZero) + #13 +
      'I_PostenLines=' + inttostr(I_PostenLines) + #13 +
      'I_OtherSortiment=' + inttostr(I_OtherSortiment) + #13
      );
  end;
  progressbar3.position := 0;
  AllData.Sort;
  FName := DiagnosePath + 'Verkäufe ' + inttostr(TheRid) + ' ' +
    inttostrN(DateTime2Long(DateTimePicker1.Date), 8) + '-' +
    inttostrN(DateTime2Long(DateTimePicker2.Date), 8) +
    '.txt';
  AllData.SaveToFile(FName);

  screen.cursor := crdefault;
  ShowMessage(inttostr(AllData.count) + ' Datensätze unter' + #13 +
    FName + #13 +
    'abgelegt!');
  AllData.free;
end;

procedure TFormArtikelSortiment.DateTimePicker1Change(Sender: TObject);
begin
  CalcTheDiff;
end;

procedure TFormArtikelSortiment.DateTimePicker2Change(Sender: TObject);
begin
  CalcTheDiff;
end;

procedure TFormArtikelSortiment.CalcTheDiff;
begin
  StaticText6.Caption := inttostr(succ(DateDiff(DateTime2Long(DateTimePicker1.Date), DateTime2Long(DateTimePicker2.Date)))) + ' Tag(e)';
end;

procedure TFormArtikelSortiment.EnsureCache;
var
  ThisValue: TDouble;
begin

  if not (assigned(SortimentMwStCache)) then
  begin
    SortimentMwStCache := TStringList.create;
    LagerCache := TStringList.create;
    IB_Query2.open;
    with IB_Query1 do
    begin
      Open;
      first;
      while not (eof) do
      begin
        ThisValue := TDouble.create;
        IB_Query2.ParamByName('CROSSREF').AsInteger := FieldByName('MWST_R').AsInteger;
        ThisValue.wert := IB_Query2.FieldByName('SATZ').AsDouble;
        SortimentMwStCache.addobject(inttostr(FieldByName('RID').AsInteger), ThisValue);

        if (FieldByName('LAGER').AsString <> 'N') then
          LagerCache.addobject(inttostr(FieldByName('RID').AsInteger), pointer(1))
        else
          LagerCache.addobject(inttostr(FieldByName('RID').AsInteger), pointer(0));

        next;
      end;
      SortimentMwStCache.sort;
      SortimentMwStCache.sorted := true;
      LagerCache.sort;
      LagerCache.sorted := true;
    end;
  end;
end;

procedure TFormArtikelSortiment.FormDeactivate(Sender: TObject);
begin
  DisableCache;
end;

procedure TFormArtikelSortiment.DisableCache;
begin
  freeAndNil(SortimentMwStCache);
  freeAndNil(LagerCache);
end;

procedure TFormArtikelSortiment.Button4Click(Sender: TObject);
var
  StartD, EndeD, ThisD, ThisLastD: TAnfixDate;
  RIDOkList: TStringList;
  RIDOk: integer;
  HeaderLine: string;
  DataLine: string;
  Verkaufsmenge: integer;
  OutL: TStringList;
  ArtikelInfo: TStringList;
  ColumnCount: integer;
  n: integer;
  MoreArtikelInfo: TStringList;
  InpStr: string;
  LastTime: dword;
  RecN: integer;

  procedure addArtikel(_RID: string; Column: integer; Menge: integer);
  var
    Sub: TStringList;
    k: integer;
  begin
    k := ArtikelInfo.indexof(_RID);
    if (k = -1) then
    begin
      Sub := TStringList.create;
      ArtikelInfo.InsertObject(0, _RID, Sub);
      k := 0;
    end;
    Sub := TStringList(ArtikelInfo.objects[k]);
    while Sub.count < succ(Column) do
      Sub.add('0');

    Sub[Column] := inttostr(strtoint(Sub[Column]) + Menge);
  end;

  procedure CompleteArtikelColumnsTo(ColumnCount: integer);
  var
    Sub: TStringList;
    n: integer;
  begin
    for n := 0 to pred(ArtikelInfo.Count) do
    begin
      Sub := TStringList(ArtikelInfo.objects[n]);
      while (Sub.count < ColumnCount) do
        Sub.add('0');
    end;
  end;

  procedure add(RID: integer);
  var
    IBQ: TIB_Query;
    InpStr: string;
  begin
    if RIDOkList.IndexOf(inttostr(RID)) = -1 then
    begin
      RIDokList.Add(inttostr(RID));
      IBQ := DataModuleDatenbank.nQuery;
      with IBQ do
      begin
        sql.Add('SELECT INTERN_INFO FROM ARTIKEL WHERE RID=:CROSSREF');
        ParamByNAme('CROSSREF').AsInteger := RID;
        Open;
        if not (IsEmpty) then
        begin
          FieldByName('INTERN_INFO').AssignTo(MoreArtikelInfo);
          InpStr := MoreArtikelInfo.values['WERBE'];
          if InpStr = '' then
            InpStr := MoreArtikelInfo.values['Werbe'];
          while (InpStr <> '') do
            add(strtol(nextp(InpStr, ';')));
        end;
        close;
      end;
      IBQ.Free;
    end;
  end;

begin
  StartD := datetime2long(DateTimePicker3.DateTime);
  EndeD := datetime2long(DateTimePicker4.DateTime);
  ThisD := StartD;
  RIDOk := strtol(edit1.text);

  BeginHourGlass;

    // einzelne Artikel, kummuliert
  RIDOkList := TStringList.create;
  ArtikelInfo := TStringList.create;
  MoreArtikelInfo := TStringList.create;
  LastTime := 0;

  if RadioButton6.Checked then
  begin
     // Lean

    with IB_Query9 do
    begin
      Open;
      label4.Caption := 'Artikel durchsuchen ...';
      ProgressBar4.Max := RecordCount;
      RecN := 0;

      while not (eof) do
      begin
        inc(RecN);
        FieldByName('INTERN_INFO').AssignTo(MoreArtikelInfo);
        InpStr := MoreArtikelInfo.values['WERBE'];
        if InpStr = '' then
          InpStr := MoreArtikelInfo.values['Werbe'];
        while (InpStr <> '') do
        begin
          if strtol(nextp(InpStr, ';')) = RIDOk then
          begin
            RIDOkList.add(FieldByName('RID').AsString);
            break;
          end;
        end;
        next;
        if frequently(LastTime, 333) or eof then
        begin
          application.ProcessMessages;
          progressbar4.position := RecN;
        end;
      end;
      Close;
    end;

  end else
  begin
     // Hirarchische Lösung
    if not (CheckBox1.Checked) then
    begin
      add(strtol(edit1.Text));
      ShowMessage(inttostr(RIDOKList.count) + ' Artikel!');
    end;

  end;

  RIDOKList.Sort;
  RIDOKList.Sorted := true;

  HeaderLine := ';';
  DataLine := '"Summe";';
  ColumnCount := 0;

  repeat
    inc(ColumnCount);
    ThisLastD := date2long(inttostrN(LastDayOfMonth(ThisD), 2) +
      copy(long2date(ThisD), 3, MaxInt));
    HeaderLine := HeaderLine + '"' + copy(cMonatNamenLang[strtoint(copy(long2date(ThisD), 4, 2))], 1, 3) +
      '-' +
      copy(long2date(ThisD), 7, 4) + '";';
    Verkaufsmenge := 0;
    with IB_query7 do
    begin
      ParamByName('DATE1').AsDate := long2dateTime(ThisD);
      ParamByName('DATE2').AsDate := long2dateTime(ThisLastD);
      Open;
      RecN := 0;
      Progressbar4.Max := RecordCount;
      while not (eof) do
      begin
        inc(RecN);
        with IB_query8 do
        begin
          ParamByName('CROSSREF').AsInteger := IB_query7.FieldByName('RID').AsInteger;
          Open;
          while not (eof) do
          begin
            if (RIDOkList.IndexOf(FieldByName('ARTIKEL_R').AsString) <> -1) or
              CheckBox1.Checked then
            begin
              addArtikel(FieldByName('ARTIKEL_R').AsString, pred(ColumnCount), FieldByName('MENGE_GELIEFERT').AsInteger);
              Verkaufsmenge := Verkaufsmenge + FieldByName('MENGE_GELIEFERT').AsInteger;
            end;
            next;
          end;
          Close;
        end;
        next;
        if frequently(LastTime, 333) or eof then
        begin
          label4.caption := 'Belege ' + long2date(ThisD) + ' - ' + long2date(ThisLastD);
          application.ProcessMessages;
          progressbar4.position := RecN;
        end;
      end;
      Close;
    end;
    DataLine := DataLine + inttostr(Verkaufsmenge) + ';';
    ThisD := DatePlus(ThisLastD, 1);
  until (ThisD > EndeD);
  label4.caption := 'Nachsorge ...';
  application.ProcessMessages;
  ArtikelInfo.sort;
  CompleteArtikelColumnsTo(ColumnCount);

  RIDOKList.SaveToFile(DiagnosePath + 'Verkaufsstatistik-Umfang.txt');
  RIDOkList.free;

  OutL := TStringList.Create;
  OutL.add(HeaderLine);

  with IB_Query4 do
  begin
    for n := 0 to pred(ArtikelInfo.Count) do
    begin
      ParamByName('CROSSREF').AsInteger := strtoint(ArtikelInfo[n]);
      if not (active) then
        Open;
      OutL.add('"' + nosemi(FieldByName('TITEL').AsString) + '"' + ';' + HugeSingleLine(TStringList(ArtikelInfo.objects[n]), ';'));
    end;
    close;
  end;
  OutL.add(DataLine);

  OutL.SaveToFile(DiagnosePath + 'Verkaufsstatistik.csv');
  OutL.Free;

  for n := 0 to pred(ArtikelInfo.count) do
    TStringList(ArtikelInfo.objects[n]).free;
  ArtikelInfo.free;
  MoreArtikelInfo.free;

  EndHourGlass;
  Progressbar4.position := 0;

  ShowMessage('Beendet! Mehr Infos in' + #13 +
    DiagnosePath + 'Verkaufsstatistik-Umfang.txt' + #13 +
    DiagnosePath + 'Verkaufsstatistik.csv');

end;

procedure TFormArtikelSortiment.CheckBox1Click(Sender: TObject);
begin
  edit1.enabled := not (CheckBox1.Checked);
  if CheckBox1.Checked then
    RadioButton5.Checked := true;
end;

procedure TFormArtikelSortiment.Button5Click(Sender: TObject);
begin
  close;
end;

procedure TFormArtikelSortiment.IB_Query10BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  IB_DataSet.FieldByName('SORTIMENT_R').Assign(IB_Query1.FieldByName('RID'));
end;

procedure TFormArtikelSortiment.SortimentChange(SORTIMENT_R: integer;
  NETTO: boolean);
var
  ARTIKEL: TIB_Query;
  MWST: TIB_Cursor;
  MwStSatz: double;
  Preis: double;
begin
  if doit('Sollen vorhandene Preise umgerechnet werden') then
  begin
    BeginHourGlass;

    // MwSt
    MWST := DataModuleDatenbank.nCursor;
    with MWST do
    begin
      sql.add('select m.satz from sortiment s');
      sql.add('join mwst m on s.mwst_r=m.rid');
      sql.add('where s.RID=' + inttostr(SORTIMENT_R));
      ApiFirst;
      MwStSatz := 1.0 + FieldByName('SATZ').AsDouble / 100.0;
    end;
    MWST.free;

    // Artikel
    ARTIKEL := DataModuleDatenbank.nQuery;
    with ARTIKEL do
    begin
      sql.add('SELECT EURO FROM ARTIKEL WHERE SORTIMENT_R=' + inttostr(SORTIMENT_R));
      sql.add('FOR UPDATE');
      open;
      first;
      while not (eof) do
      begin
        if FieldByName('EURO').IsNotNull then
        begin
          Preis := FieldByName('EURO').AsDouble;
          if NETTO then
            Preis := cPreisRundung(Preis / MwStSatz)
          else
            Preis := cPreisRundung(Preis * MwStSatz);

          edit;
          FieldByName('EURO').AsDouble := Preis;
          post;
        end;

        next;
      end;
      close;
    end;
    ARTIKEL.free;
    EndHourGlass;
  end;
end;

procedure TFormArtikelSortiment.SpeedButton1Click(Sender: TObject);
begin
  Neu;
end;

procedure TFormArtikelSortiment.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
var
  OldNetto: boolean;
  NewNetto: boolean;
  SORTIMENT: TIB_Cursor;
begin
  if IB_Dataset.FieldByName('RID').IsNotNull then
  begin
    SORTIMENT := DataModuleDatenbank.nCursor;
    with SORTIMENT do
    begin
      sql.add('select NETTO from SORTIMENT where RID=' + IB_Dataset.FieldByName('RID').AsString);
      ApiFirst;
      OldNEtto := FieldByNAme('NETTO').AsString = cC_True;
      close;
    end;
    SORTIMENT.free;
    NewNetto := IB_Dataset.FieldByName('NETTO').AsString = cC_True;
    if (OldNetto <> NewNetto) then
      SortimentChange(IB_Dataset.FieldByName('RID').AsInteger, NewNetto);
  end;
end;

procedure TFormArtikelSortiment.Neu;
var
  SORTIMENT: TIB_Query;
  MWST: TIB_Cursor;
  MWST_R: integer;
begin

  // default MWST
  MWST := DataModuleDatenbank.nCursor;
  with MWST do
  begin
    sql.add('select RID from mwst order by satz descending');
    ApiFirst;
    MWST_R := FIeldbyname('RID').AsINteger;
  end;
  MWST.free;

  // create new Sortiment
  SORTIMENT := DataModuleDatenbank.nQuery;
  with SORTIMENT do
  begin
    sql.add('select * from sortiment for update');
    insert;
    FieldByName('RID').AsInteger := 0;
    FieldByName('NAECHSTE_NUMMER').AsInteger := -1;
    FieldByName('BEZEICHNUNG').AsString := 'neues Sortiment';
    FieldByName('MWST_R').AsInteger := MWST_R;
    post;
  end;
  SORTIMENT.free;
  IB_Query1.refresh;
  IB_Query1.locate('BEZEICHNUNG', 'neues Sortiment', []);
end;

procedure TFormArtikelSortiment.setContext(SORTIMENT_R: integer);
begin
  //
  mShow;
  IB_Query1.Locate('RID',SORTIMENT_R,[]);
end;

procedure TFormArtikelSortiment.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Sortiment');
end;

procedure TFormArtikelSortiment.mShow;
begin
  WindowState := wsnormal;
  show;
end;

procedure TFormArtikelSortiment.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  BeginHourGlass;
  label11.Caption := e_r_sqls('select count(rid) from artikel where sortiment_r=' + inttostr(IB_Query1.FieldByName('RID').AsInteger));
  EndHourGlass;
end;

procedure TFormArtikelSortiment.Button7Click(Sender: TObject);
begin
  FormArtikel.SetContext('WHERE (SORTIMENT_R='+inttostr(IB_Query1.FieldByName('RID').AsInteger)+')');
end;

end.

