unit LiefMahn;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  IB_NavigationBar,
  IB_Components,
  IB_Access,
  Vcl.Grids,
  IB_Grid,
  System.Generics.Collections,
  Vcl.Buttons,
  WordIndex;

type
  TLandLst = TList<Integer>;

  TFormLiefMahn = class(TForm)
    GridBelege: TIB_Grid;
    QueryBelege: TIB_Query;
    DSBelege: TIB_DataSource;
    pnlBottom: TPanel;
    Label2: TLabel;
    edtMahnOffset: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtSenderR: TEdit;
    edtVorlageR_DEU: TEdit;
    pnlTop: TPanel;
    IB_NavigationBar1: TIB_NavigationBar;
    btnLiefMahnlaufStart: TButton;
    btnLiefMahnVersenden: TButton;
    Image2: TImage;
    pnlLog: TPanel;
    memLog: TMemo;
    lblStatus: TLabel;
    cbMahnOffset: TCheckBox;
    lblLastMahnlauf: TLabel;
    Label1: TLabel;
    edtVorlageR_ENG: TEdit;
    edtLaenderDEULst: TEdit;
    Länder_R: TLabel;
    btnPerson: TButton;
    btnBestellung: TButton;
    btnMahnsperre: TSpeedButton;
    btnDelMahnsperren: TButton;
    QueryPosten: TIB_Query;
    procedure btnLiefMahnlaufStartClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure btnLiefMahnVersendenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPersonClick(Sender: TObject);
    procedure btnBestellungClick(Sender: TObject);
    procedure btnMahnSperreClick(Sender: TObject);
    procedure btnDelMahnsperrenClick(Sender: TObject);
  private
    FLastMahnlauf: TDateTime;
    FLandLst: TLandLst;
    procedure RefreshQuery;
    function GetBelegFilter:String;
    function GetVorlage(AVorlage_R: Integer): String;
    function GetQryPosten:String;
{$HINTS OFF}
    function GetPosten(AQry:TIB_Query; ABBeleg_RID: Integer; AFieldName: String): String; overload;
{$HINTS ON}
    function GetPosten(AQry:TIB_Query; ALang:String; ABBeleg_RID: Integer): String; overload;

    procedure SaveEinst;
    procedure LoadEinst;
    procedure LoadLandLst(ALandLst: String);
    function IsInList(ALandRID: Integer): Boolean;

    function MarkedPERSON_R: Integer;  //Lieferant
    function MarkedBELEG_R:Integer;  //Bestellung
    function MarkedKUNDE_R:Integer; //Kunde

{$HINTS OFF}
    procedure BPosten_UpdateZusage(ABPostenRID: Integer; AZusage: TDateTime);
{$HINTS ON}
    Procedure InsertEmail(APerson_R, ASender_R, AVorlage_R: Integer;
      ANachricht, AEmpfaenger: String);
  public
    //
       ItemsMARKED: TExtendedList;
  end;

const
  cSectionLiefMahn = 'LIEFMAHN';
  cZusageTageOffset = 2; //Offset der Tage um die Posten zu ermitteln wg Feiertag/Wochenende

var
  FormLiefMahn: TFormLiefMahn;

implementation

{$R *.dfm}

uses
  Wanfix,
  CareTakerClient,
  Datenbank,
  Globals,
  iniFiles,
  Person,
  dbOrgaMon, BestellArbeitsplatz, bbelege;

procedure TFormLiefMahn.btnBestellungClick(Sender: TObject);
begin
  //Bestellbeleg oeffnen
  FormBBelege.setContext(MarkedKUNDE_R, MarkedBELEG_R {PostenId});
  FormBBelege.show;
end;

procedure TFormLiefMahn.btnDelMahnsperrenClick(Sender: TObject);
begin
  ItemsMARKED.Clear;
  RefreshQuery;
end;

procedure TFormLiefMahn.btnLiefMahnlaufStartClick(Sender: TObject);
begin
  RefreshQuery;
end;

procedure TFormLiefMahn.RefreshQuery;
begin

  QueryBelege.SQL.Text := 'Select ' +
    'BB.RID as BBELEG_RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT,BB.PERSON_R, ' +
    'P.RID as PERSON_RID, P.NACHNAME, P.VORNAME, P.EMAIL, P.ANREDE, P.ANSPRACHE, A.NAME1, A.LAND_R, ' +
    'BP.LIEFERANT_R, ' +
    'Count(BP.RID) as ANZPOS ' +
    'from BBELEG BB ' +
    'JOIN BPOSTEN BP on BB.RID=BP.BELEG_R ' +
    'JOIN PERSON P on BP.LIEFERANT_R=P.RID ' +

    'JOIN ANSCHRIFT A ON A.RID=P.PRIV_ANSCHRIFT_R ' +
    'where BB.MENGE_ERWARTET > BB.MENGE_GELIEFERT ' +
    'and (BP.MENGE_ERWARTET>0 and BP.ZUSAGE+' + inttostr(cZusageTageOffset) + '<CURRENT_DATE) ' +
    GetBelegFilter +
    'group by ' +
    'BB.RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT,BB.PERSON_R, ' +
    'P.RID, P.NACHNAME, P.VORNAME, P.Email, P.ANREDE, P.ANSPRACHE, A.NAME1,A.LAND_R, BP.LIEFERANT_R ';

  BeginHourGlass;
  QueryBelege.close;
  if not(QueryBelege.active) then
    QueryBelege.Open;

  QueryBelege.Last;
  QueryBelege.First;

  EndHourGlass;

  btnLiefMahnVersenden.Enabled := ((QueryBelege.RecordCount > 0) = True);

  lblStatus.Caption := 'Es wurden ' + QueryBelege.RecordCount.ToString +
    ' Belege zum Mahnen gefunden!';
  lblStatus.Visible := ((QueryBelege.RecordCount > 0) = True);
end;


procedure TFormLiefMahn.btnLiefMahnVersendenClick(Sender: TObject);
var
  x,y: Integer;
  cnt: Integer;
  cntFehler: Integer;
  lMahnOffsetTage: Integer;
  lSenderR: Integer;
  lVorlageR_DEU: Integer;
  lVorlageR_ENG: Integer;
  lNachricht: String;
  lLang: String;
  lBBELEG_RID: Integer;
  lPositionen: String;
begin
  BeginHourGlass;
  memLog.Clear;

  if not TryStrToInt(edtMahnOffset.Text, lMahnOffsetTage) then
    ShowMessage('Nächste Mahnung hat einen ungültigen Wert!');

  if not TryStrToInt(edtSenderR.Text, lSenderR) then
    ShowMessage('Sender_R hat einen ungültigen Wert!');

  if not TryStrToInt(edtVorlageR_DEU.Text, lVorlageR_DEU) then
    ShowMessage('Vorlage_R (Deutsch) hat einen ungültigen Wert!');

  if not TryStrToInt(edtVorlageR_ENG.Text, lVorlageR_ENG) then
    ShowMessage('Vorlage_R (Englisch) hat einen ungültigen Wert!');

  lBBELEG_RID := 0;
  lPositionen := '';
  cnt := 0;
  cntFehler := 0;
  QueryBelege.First;

  LoadLandLst(edtLaenderDEULst.Text);

  for x := 0 to QueryBelege.RecordCount - 1 do
  begin
    // Vorlage laden
    if IsInList(QueryBelege.FieldByName('LAND_R').asInteger) then
    begin
      lNachricht := GetVorlage(lVorlageR_DEU);
      lLang := 'DEU'
    end
    else
    begin
      lNachricht := GetVorlage(lVorlageR_ENG);
      lLang := 'ENG';
    end;

    if length(QueryBelege.FieldByName('EMAIL').asString) > 0 then
    begin
      lBBELEG_RID := QueryBelege.FieldByName('BBELEG_RID').asInteger;

      // Versende-Modus  (Hier Vorlage verwenden)
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.ANREDE~',
        QueryBelege.FieldByName('ANREDE').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.VORNAME~',
        QueryBelege.FieldByName('VORNAME').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.NACHNAME~',
        QueryBelege.FieldByName('NACHNAME').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.ANSPRACHE~',
        QueryBelege.FieldByName('ANSPRACHE').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.NAME1~',
        QueryBelege.FieldByName('NAME1').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.RIDLIEFERANT~',
        QueryBelege.FieldByName('LIEFERANT_R').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.LIEFERANT_R~',
        QueryBelege.FieldByName('LIEFERANT_R').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.EMAIL~',
        QueryBelege.FieldByName('EMAIL').asString, [rfReplaceAll]);

      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.POSITIONEN~',
        GetPosten(QueryPosten, lLang, lBBELEG_RID), [rfReplaceAll]);

      InsertEmail(QueryBelege.FieldByName('LIEFERANT_R').asInteger, lSenderR,
        -1{lVorlageR}, lNachricht, QueryBelege.FieldByName('EMAIL').asString);

      // Zusage setzen, damit Mahnung nicht mehrfach
      // Klappt nur Bedingt besser z.B. Datum Nächste Mahnung + Mahnzähler
      if cbMahnOffset.Checked then
      begin
        QueryPosten.Sql.Text := GetQryPosten;
        QueryPosten.ParamByName('RID').asInteger := lBBELEG_RID;

            try
              QueryPosten.active := True;
            except
              //
            end;

            QueryPosten.Last;
            QueryPosten.First;

        QueryPosten.Active := True;
        for y := 0 to QueryPosten.RecordCount-1 do
        begin
          BPosten_UpdateZusage(QueryPosten.FieldByName('RID').asInteger,
            now + lMahnOffsetTage);
          QueryPosten.Next;
        end;

      end;

      inc(cnt);
      // So geht es auch!
      // e_x_sql('insert into ' + result + ' (RID) ' + sql);

    end
    else
    begin
      memLog.Lines.Add
        ('Fehler! Mahnung kann nicht erstellt werden! Email hat keinen Wert! (Person.RID:'
        + QueryBelege.FieldByName('LIEFERANT_R').asString + ' ' +
        QueryBelege.FieldByName('NACHNAME').asString + ' ' +
        QueryBelege.FieldByName('VORNAME').asString + ' BBelegRID:' +
        lBBELEG_RID.ToString + ')');
      inc(cntFehler);

    end;

    QueryBelege.next;

  end;
  EndHourGlass;

  lblStatus.Caption := 'Es wurden ' + cnt.ToString +
    ' Lieferantenmahnungen erstellt! (' + cntFehler.ToString + ' Fehler!)';

  FLastMahnlauf := now;
  lblLastMahnlauf.Caption := 'Letzter Mahnlauf: ' +
    dateTimetostr(FLastMahnlauf);

  ShowMessage('Es wurden ' + cnt.ToString + ' Lieferantenmahnungen erstellt! ' +
    cntFehler.ToString + ' konnten nicht erstellt werden!' + #13#10 +
    'Bitte führen Sie nun im Modul Email den Versand durch!');

  RefreshQuery;
end;

procedure TFormLiefMahn.btnMahnSperreClick(Sender: TObject);
var
  tmpBelegId: Integer;
begin

  QueryBelege.DisableControls;

  ItemsMARKED.Add(TObject(QueryBelege.FieldByName('BBELEG_RID').AsInteger));
  QueryBelege.Next;
  tmpBelegId := QueryBelege.FieldByName('BBELEG_RID').AsInteger;
  RefreshQuery;

  QueryBelege.Locate('BBELEG_RID',tmpBelegId,[]);
  QueryBelege.EnableControls;
end;

procedure TFormLiefMahn.btnPersonClick(Sender: TObject);
begin
  FormPerson.SetContext(MarkedPERSON_R);
end;

procedure TFormLiefMahn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveEinst;
end;

procedure TFormLiefMahn.FormCreate(Sender: TObject);
begin
  FLandLst := TLandLst.Create;
  ItemsMARKED := TExtendedList.create;
end;

procedure TFormLiefMahn.FormDestroy(Sender: TObject);
begin
  FLandLst.Free;
  ItemsMARKED.Free;
end;

procedure TFormLiefMahn.FormShow(Sender: TObject);
begin
  lblStatus.Caption := '';

  LoadEinst;

  lblLastMahnlauf.Caption := 'Letzter Mahnlauf: ' +
    dateTimetostr(FLastMahnlauf);

  RefreshQuery;
end;

function TFormLiefMahn.GetBelegFilter: String;
var
x: Integer;
begin
  Result := '';
  if ItemsMARKED.Count>0 then
  begin
    for x:=0 to ItemsMARKED.Count-1 do
    begin
      Result := Result + Integer(ItemsMARKED.Items[x]).ToString + ','; //indexof
    end;

    Result := copy(Result,0,length(Result)-1);

    Result := ' AND BB.RID NOT IN (' + Result+ ') ';
  end;

end;

function TFormLiefMahn.GetQryPosten: String;
begin
  Result := 'Select BP.RID, BP.ARTIKEL, BP.POSNO, BP.PREIS, BP.MENGE, BP.ZUSAGE, ' +
            'BP.BELEG_R, BP.VERLAG_R as RIDVERLAG, A.VERLAGNO, A.RID as ARTIKEL_RID, ' +
            'VERL.NAME1 as VERL_NAME1,VERL.NAME2 as VERL_NAME2 ' +
            'FROM BPOSTEN BP ' +
            'JOIN ARTIKEL A on BP.ARTIKEL_R = A.RID ' +
            'LEFT JOIN PERSON V on BP.VERLAG_R = V.RID ' +
            'JOIN ANSCHRIFT VERL ON VERL.RID = V.PRIV_ANSCHRIFT_R ' +
            'WHERE (BP.MENGE_ERWARTET>0 AND BP.ZUSAGE+' + inttostr(cZusageTageOffset) + '<CURRENT_DATE) ' +
            'AND BP.BELEG_R=:RID';
end;

function TFormLiefMahn.GetPosten(AQry:TIB_Query; ABBeleg_RID: Integer; AFieldName: String): String;
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := GetQryPosten;

    q.ParamByName('RID').asInteger := ABBeleg_RID;

    try
      q.active := True;
    except
      //
    end;

    Result := q.FieldByName(AFieldName).asString;

  finally
    q.Free;
  end;

end;

function TFormLiefMahn.GetPosten(AQry:TIB_Query; ALang:String; ABBeleg_RID: Integer): String;

function FillLeft(Input: String; Feldlaenge: Integer): String;
var
  x: Integer;
begin
  if length(Input) >= Feldlaenge then
    Result := copy(Input, 0, Feldlaenge)
  else
  begin
    Result := Input;
    for x := 0 to Feldlaenge - length(Input) - 1 do
    begin
      Result := ' ' + Result
    end;

  end;
end;

function FillRight(Input: String; Feldlaenge: Integer): String;
begin
// feste Länge
  Result :=Input;
  while length(Result)< Feldlaenge do  //Als Text
  begin
    Result := Result + ' ';
  end;

  //Mit Tabs
  //  Result :=Input;
  //  anz := (Feldlaenge - length(Input)) div 8;  //RTF-Formatierung mit Tabs
  //  for x:= 0 to Anz-1 do
  //     Result := Result + #9;

end;

function Translate(ALang:String; ATitelDEU, ATitelENG:String):string;
begin
  if ALang='DEU' then
    Result := ATitelDEU + ': '
    else
    Result := ATitelENG + ': ';
end;

function Kuerz(AValue:String;ALength:Integer):String;
begin
  Result := AValue;
  if length(Result) > ALength then
    Result := copy(Result, 0, ALength-3) + '...';
end;

var
  q: TIB_Query;
  x: Integer;
begin

  Result := '';
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := GetQryPosten;

    q.ParamByName('RID').asInteger := ABBeleg_RID;

    try
      q.active := True;
    except
      //
    end;

    q.Last;
    q.First;

    //Positionen
    for x := 0 to q.RecordCount - 1 do
    begin
      Result := Result +
      FillRight(Translate(ALang, 'BestellungNr', 'Order No'), 30) +  q.FieldByName('BELEG_R').asString + #13#10 +
      FillRight(Translate(ALang, 'Menge', 'Ammount'), 30) + q.FieldByName('MENGE').asString + #13#10 +
      FillRight(Translate(ALang, 'Artikelnummer', 'Product ID'), 30) + q.FieldByName('VERLAGNO').AsString +#13#10 +
      FillRight(Translate(ALang, 'Bezeichnung', 'Description'), 30) + Kuerz(q.FieldByName('ARTIKEL').asString, 60) + #13#10 +
      FillRight(Translate(ALang, 'Preis', 'Price'), 30) + FloatToStrF(q.FieldByName('PREIS').AsFloat, ffNumber, 15,2) + ' EUR' + #13#10 +
      FillRight(Translate(ALang, 'Erwarteter Liefertermin', 'exp. Delivery Time'), 30) + datetostr(q.FieldByName('ZUSAGE').AsDate) + #13#10 +
      FillRight(Translate(ALang, 'Verlag', 'Publisher'), 30) + Kuerz(q.FieldByName('RIDVERLAG').AsString + ' ' + q.FieldByName('VERL_NAME1').AsString + q.FieldByName('VERL_NAME2').AsString,60);

      if (x < (q.RecordCount - 1)) then
        Result := Result + #13#10 + #13#10;

      q.next;
    end;

  finally
    q.Free;
  end;

end;

function TFormLiefMahn.GetVorlage(AVorlage_R: Integer): String;
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := 'SELECT NACHRICHT ' + 'FROM EMAIL ' + 'WHERE RID=:RID';

    q.ParamByName('RID').asInteger := AVorlage_R;

    try
      q.active := True;
    except
      //
    end;

    Result := q.FieldByName('NACHRICHT').asString;

  finally
    q.Free;
  end;

end;

procedure TFormLiefMahn.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'LiefMahn');
end;

procedure TFormLiefMahn.BPosten_UpdateZusage(ABPostenRID: Integer;
  AZusage: TDateTime);
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := 'UPDATE BPOSTEN ' +
                  'SET ZUSAGE=:ZUSAGE ' +
                  'WHERE RID=:RID';

    q.ParamByName('RID').asInteger := ABPostenRID;
    q.ParamByName('ZUSAGE').AsDateTime := AZusage;

    try
      q.ExecSQL;
    except
      //
    end;

  finally
    q.Free;
  end;

end;

procedure TFormLiefMahn.InsertEmail(APerson_R, ASender_R, AVorlage_R: Integer;
  ANachricht, AEmpfaenger: String);
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text :=
      'INSERT INTO EMAIL (PERSON_R,SENDER_R,VORLAGE_R,NACHRICHT, EMPFAENGER) ' + // RID/UID)
      'VALUES (:PERSON_R,:SENDER_R,:VORLAGE_R,:NACHRICHT, :EMPFAENGER);';

    q.ParamByName('PERSON_R').asInteger := APerson_R;
    q.ParamByName('SENDER_R').asInteger := ASender_R;
    if AVorlage_R>0 then
      q.ParamByName('VORLAGE_R').asInteger := AVorlage_R
      else
      q.ParamByName('VORLAGE_R').Clear;

    q.ParamByName('NACHRICHT').asString := ANachricht;
    q.ParamByName('EMPFAENGER').asString := AEmpfaenger;

    try
      q.ExecSQL;
    except
      //
    end;

  finally
    q.Free;
  end;
end;

function TFormLiefMahn.IsInList(ALandRID: Integer): Boolean;
var
  x: Integer;
begin
  Result := False;
  for x := 0 to FLandLst.Count - 1 do
  begin
    if FLandLst[x] = ALandRID then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFormLiefMahn.LoadEinst;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(MyProgramPath + cIniFName);
  try
    edtSenderR.Text := ini.ReadString(cSectionLiefMahn, 'Sender_R', '');
    edtVorlageR_DEU.Text := ini.ReadString(cSectionLiefMahn,
      'Vorlage_R_DEU', '');
    edtLaenderDEULst.Text := ini.ReadString(cSectionLiefMahn,
      'LandLst_DEU', '');
    edtVorlageR_ENG.Text := ini.ReadString(cSectionLiefMahn,
      'Vorlage_R_ENG', '');

    cbMahnOffset.Checked := ini.ReadBool(cSectionLiefMahn, 'EnableMahnOffset', False);


    edtMahnOffset.Text := ini.ReadString(cSectionLiefMahn, 'MahnOffset', '7');
    FLastMahnlauf := ini.ReadDateTime(cSectionLiefMahn, 'LastMahnlauf', 0);
  finally
    ini.Free;
  end;
end;

procedure TFormLiefMahn.LoadLandLst(ALandLst: String);
var
  x: Integer;
  li: Integer;
begin

  FLandLst.Clear;
  for x := low(ALandLst.Split([','])) to High(ALandLst.Split([','])) do
    if TryStrToInt(ALandLst.Split([','])[x], li) then
      FLandLst.Add(li)
    else
      Exception.Create('Fehler beim Einlesen der Länderliste!');
end;

function TFormLiefMahn.MarkedBELEG_R: Integer;
begin
  if QueryBelege.Active then
    result := QueryBelege.FieldByName('BBELEG_RID').AsInteger
  else
    result := cRID_Null;
end;

function TFormLiefMahn.MarkedKUNDE_R: Integer;
begin
  if QueryBelege.Active then
    result := QueryBelege.FieldByName('PERSON_R').AsInteger
  else
    result := cRID_Null;
end;

function TFormLiefMahn.MarkedPERSON_R: Integer;
begin
  if QueryBelege.Active then
    result := QueryBelege.FieldByName('PERSON_RID').AsInteger
  else
    result := cRID_Null;
end;


procedure TFormLiefMahn.SaveEinst;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(MyProgramPath + cIniFName);
  try
    ini.WriteString(cSectionLiefMahn, 'Sender_R', edtSenderR.Text);
    ini.WriteString(cSectionLiefMahn, 'Vorlage_R_DEU', edtVorlageR_DEU.Text);
    ini.WriteString(cSectionLiefMahn, 'LandLst_DEU', edtLaenderDEULst.Text);
    ini.WriteString(cSectionLiefMahn, 'Vorlage_R_ENG', edtVorlageR_ENG.Text);
    ini.WriteBool(cSectionLiefMahn, 'EnableMahnOffset', cbMahnOffset.Checked);
    ini.WriteString(cSectionLiefMahn, 'MahnOffset', edtMahnOffset.Text);
    ini.WriteDateTime(cSectionLiefMahn, 'LastMahnlauf', FLastMahnlauf);
  finally
    ini.Free;
  end;
end;

end.
