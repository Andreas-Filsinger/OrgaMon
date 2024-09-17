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
  System.Generics.Collections;

type
  TLandLst = TList<Integer>;

  TFormLiefMahn = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    pnlBottom: TPanel;
    Label2: TLabel;
    edtMahnOffset: TEdit;
    btnMahnSperre: TButton;
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
    procedure btnLiefMahnlaufStartClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure btnLiefMahnVersendenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLastMahnlauf: TDateTime;
    FLandLst: TLandLst;
    function GetVorlage(AVorlage_R: Integer): String;
{$HINTS OFF}
    function GetPosten(ABBeleg_RID: Integer; AFieldName: String)
      : String; overload;
{$HINTS ON}
    function GetPosten(ABBeleg_RID: Integer): String; overload;

    procedure SaveEinst;
    procedure LoadEinst;
    procedure LoadLandLst(ALandLst: String);
    function IsInList(ALandRID: Integer): Boolean;

{$HINTS OFF}
    procedure BPosten_UpdateZusage(AArtikelRID: Integer; AZusage: TDateTime);
{$HINTS ON}
    Procedure InsertEmail(APerson_R, ASender_R, AVorlage_R: Integer;
      ANachricht, AEmpfaenger: String);
  public
    //
  end;

const
  cSectionLiefMahn = ' LIEFMAHN';

var
  FormLiefMahn: TFormLiefMahn;

implementation

{$R *.dfm}

uses
  Wanfix,
  CareTakerClient,
  Datenbank,
  Globals,
  iniFiles;

procedure TFormLiefMahn.btnLiefMahnlaufStartClick(Sender: TObject);
begin
  IB_Query1.SQL.Text := 'Select ' +
    'BB.RID as BBELEG_RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT, ' +
    'V.RID as VERLAG_RID, ' +
    'P.RID as PERSON_RID, P.NACHNAME, P.VORNAME,P.EMAIL,P.ANREDE,P.ANSPRACHE,A.LAND_R, ' +
    'Count(BP.RID) as ANZPOS ' +
    'from BBELEG BB ' +
    'JOIN BPOSTEN BP on BB.RID=BP.BELEG_R ' +
    'JOIN VERLAG V on BP.VERLAG_R = V.RID ' +
    'JOIN PERSON P on V.PERSON_R=P.RID ' +
    'JOIN ANSCHRIFT A ON A.RID=P.PRIV_ANSCHRIFT_R ' +
    'where BB.MENGE_ERWARTET > BB.MENGE_GELIEFERT ' +
    'and (BP.MENGE_ERWARTET>0 and BP.ZUSAGE+2<CURRENT_DATE) ' + 'group by ' +
    'BB.RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT, ' + 'V.RID, ' +
    'P.RID, P.NACHNAME, P.VORNAME, P.Email, P.ANREDE,P.ANSPRACHE,A.LAND_R ';

  BeginHourGlass;
  if not(IB_Query1.active) then
    IB_Query1.Open;

  IB_Query1.Last;
  IB_Query1.First;

  EndHourGlass;

  if IB_Query1.RecordCount <= 0 then
    ShowMessage('Keine Belege gefunden!');

  btnLiefMahnVersenden.Enabled := ((IB_Query1.RecordCount > 0) = True);

  lblStatus.Caption := 'Es wurden ' + IB_Query1.RecordCount.ToString +
    ' Belege zum Mahnen gefunden!';
  lblStatus.Visible := ((IB_Query1.RecordCount > 0) = True);
end;

procedure TFormLiefMahn.btnLiefMahnVersendenClick(Sender: TObject);
var
  x: Integer;
  cnt: Integer;
  cntFehler: Integer;
  lMahnOffsetTage: Integer;
  lSenderR: Integer;
  lVorlageR: Integer;
  lVorlageR_DEU: Integer;
  lVorlageR_ENG: Integer;
  lNachricht: String;
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
  IB_Query1.First;

  LoadLandLst(edtLaenderDEULst.Text);

  for x := 0 to IB_Query1.RecordCount - 1 do
  begin
    // Vorlage laden
    if IsInList(IB_Query1.FieldByName('LAND_R').asInteger) then
    begin
      lVorlageR := lVorlageR_DEU;
      lNachricht := GetVorlage(lVorlageR_DEU)
    end
    else
    begin
      lNachricht := GetVorlage(lVorlageR_ENG);
      lVorlageR := lVorlageR_ENG;
    end;

    if length(IB_Query1.FieldByName('EMAIL').asString) > 0 then
    // Check Versendefaehigkeit /Email Vorhanden?
    begin
      lBBELEG_RID := IB_Query1.FieldByName('BBELEG_RID').asInteger;

      // Versende-Modus  (Hier Vorlage verwenden)
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.ANREDE~',
        IB_Query1.FieldByName('ANREDE').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.VORNAME~',
        IB_Query1.FieldByName('VORNAME').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.NACHNAME~',
        IB_Query1.FieldByName('NACHNAME').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.ANSPRACHE~',
        IB_Query1.FieldByName('ANSPRACHE').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.RIDVERLAG~',
        IB_Query1.FieldByName('VERLAG_RID').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.EMAIL~',
        IB_Query1.FieldByName('EMAIL').asString, [rfReplaceAll]);
      lNachricht := StringReplace(lNachricht, '~LIEFMAHN.POSITIONEN~',
        GetPosten(lBBELEG_RID), [rfReplaceAll]);

      InsertEmail(IB_Query1.FieldByName('VERLAG_RID').asInteger, lSenderR,
        lVorlageR, lNachricht, IB_Query1.FieldByName('EMAIL').asString);

      // Zusage setzen, damit Mahnung nicht mehrfach
      // Klappt nur Bedingt besser z.B. dateum Nächste Mahnung + Mahnzähler
      if cbMahnOffset.Checked then
        BPosten_UpdateZusage(IB_Query1.FieldByName('ARTIKELRID').asInteger,
          IB_Query1.FieldByName('ZUSAGE').AsDateTime + lMahnOffsetTage);

      inc(cnt);
      // So geht es auch!
      // e_x_sql('insert into ' + result + ' (RID) ' + sql);

    end
    else
    begin
      memLog.Lines.Add
        ('Fehler! Mahnung kann nicht erstellt werden! Email hat keinen Wert! (Person.RID:'
        + IB_Query1.FieldByName('VERLAG_RID').asString + ' ' +
        IB_Query1.FieldByName('NACHNAME').asString + ' ' +
        IB_Query1.FieldByName('VORNAME').asString + ' BBelegRID:' +
        lBBELEG_RID.ToString + ')');
      inc(cntFehler);

    end;

    IB_Query1.next;

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
end;

procedure TFormLiefMahn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveEinst;
end;

procedure TFormLiefMahn.FormCreate(Sender: TObject);
begin
  FLandLst := TLandLst.Create;
end;

procedure TFormLiefMahn.FormDestroy(Sender: TObject);
begin
  FLandLst.Free;
end;

procedure TFormLiefMahn.FormShow(Sender: TObject);

begin
  lblStatus.Caption := '';

  LoadEinst;

  lblLastMahnlauf.Caption := 'Letzter Mahnlauf: ' +
    dateTimetostr(FLastMahnlauf);

end;

function TFormLiefMahn.GetPosten(ABBeleg_RID: Integer;
  AFieldName: String): String;
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := 'Select BP.RID, BP.ARTIKEL, BP.POSNO, BP.PREIS ' +
      'FROM BPOSTEN BP ' +
      'WHERE BP.BELEG_R=:RID';

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


function TFormLiefMahn.GetPosten(ABBeleg_RID: Integer): String;

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
        Result := Result + ' '
      end;
    end;
  end;

var
  q: TIB_Query;
  x: Integer;
  lArtikel: String;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text :=
      'Select BP.RID, BP.ARTIKEL, BP.POSNO, BP.PREIS, BP.MENGE, BP.ZUSAGE ' +
      'FROM BPOSTEN BP ' +
      'WHERE BP.BELEG_R=:RID';

    q.ParamByName('RID').asInteger := ABBeleg_RID;

    try
      q.active := True;
    except
      //
    end;

    q.Last;
    q.First;

    Result := FillRight('MENGE', 8) + FillRight('BEZEICHNUNG', 62) +
      FillLeft('PREIS', 10) + FillLeft('ZUSAGE', 13) + #13#10;
    for x := 0 to q.RecordCount - 1 do
    begin
      lArtikel := q.FieldByName('ARTIKEL').asString;
      if length(lArtikel) > 60 then
        lArtikel := copy(lArtikel, 0, 57) + '...';

      Result := Result + FillRight(q.FieldByName('MENGE').asString, 8) +
        FillRight(lArtikel, 62) +
        FillLeft(FloatToStrF(q.FieldByName('PREIS').AsCurrency, ffCurrency, 15,
        2), 10) + FillLeft(datetostr((q.FieldByName('ZUSAGE').AsDate)),
        13) + #13#10;

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

procedure TFormLiefMahn.BPosten_UpdateZusage(AArtikelRID: Integer;
  AZusage: TDateTime);
var
  q: TIB_Query;
begin
  q := TIB_Query.Create(nil);
  try
    q.IB_Connection := DataModuleDatenbank.IB_Connection1;

    q.SQL.Text := 'UPDATE BPOSTEN ' + 'SET ZUSAGE=:ZUSAGE ' + 'WHERE RID=:RID';

    q.ParamByName('RID').asInteger := AArtikelRID;
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
    q.ParamByName('VORLAGE_R').asInteger := AVorlage_R;

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

    cbMahnOffset.Checked := ini.ReadBool(cSectionLiefMahn,
      'EnableMahnOffset', False);
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
