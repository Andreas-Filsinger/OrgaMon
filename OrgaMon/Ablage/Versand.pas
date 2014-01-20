unit Versand;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, HebuData,
  StdCtrls, ComCtrls, IB_Components;

type
  TFormVersand = class(TForm)
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    GroupBox1: TGroupBox;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Button2: TButton;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    Label1: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormVersand: TFormVersand;

implementation

{$R *.DFM}

uses
  anfix32, globals, AusgangsRechnungen, eCommerce;

procedure TFormVersand.Button1Click(Sender: TObject);
var
  ShowTime: dword;
  _versand_status: integer;
  _changed: integer;
  _read: integer;
  Menge_Auftrag: integer;
  Menge_Rechnung: integer;
  Menge_Bestellt: integer;
  Menge_Geliefert: integer;
  Menge_Vorschlag: integer;
begin
  BeginHourGlass;
  _changed := 0;
  _read := 0;
  IB_Query1.Open;
  IB_Query2.Open;
  FormAusgangsRechnungen.EnsureOpen;
(*
 if CheckBox1.Checked then
  if (FormAusgangsRechnungen.IB_Query1.RecordCount<>0) then
  begin
   ShowMessage('Bitte erst alle Buchungen löschen!'+#13+
               'Konto->clear');
   exit;
  end;
*)

  ProgressBar1.Max := IB_Query1.RecordCount;
  ProgressBar1.Position := 0;
  IB_Query1.First;
  with IB_Query1 do
    while not (eof) do
    begin

      inc(_read);

      IB_Query2.ParamByName('CROSSREF').AsInteger := FieldByName('RID').AsInteger;

      if DataModuleeCommerce.e_w_BelegStatusBuchen(IB_Query1) then
        inc(_changed);

      if (IB_query1.FieldByName('VERSAND_STATUS').AsInteger = cV_ZeroState + cV_Geliefert) or
        (IB_query1.FieldByName('VERSAND_STATUS').AsInteger = cV_ZeroState) then
        if (IB_query1.FieldByName('RECHNUNG').IsNull) then
        begin
          inc(_changed);
          DataModuleeCommerce.e_w_RechnungDatumSetzen(IB_Query1, IB_query1.FieldByName('ANLAGE').AsDateTime);
        end;


      if false {CheckBox1.Checked} then
      begin
        if not (IB_query1.FieldByName('RECHNUNG').IsNull) then
          with FormAusgangsRechnungen.IB_Query1 do
          begin

            insert;
            FieldByName('RID').AsInteger := 0; // nur proforma
            FieldByName('DATUM').AsDate := IB_Query1.FieldByName('RECHNUNG').AsDate;
            FieldByName('VALUTA').AsDate := IB_Query1.FieldByName('FAELLIG').AsDate;
            FieldByName('BELEG_R').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
            FieldByName('KUNDE_R').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;
            FieldByName('BETRAG').AsDouble := IB_Query1.FieldByName('RECHNUNGS_BETRAG').AsDouble;
            post;

            inc(_changed);

            if (IB_Query1.FieldByName('DAVON_BEZAHLT').AsDouble > 0.0) then
            begin
              insert;
              FieldByName('RID').AsInteger := 0; // nur proforma
              FieldByName('DATUM').AsDate := IB_Query1.FieldByName('RECHNUNG').AsDate;
//     FieldByName('VALUTA').AsDate     := FieldByName('DATUM').AsDate;
              FieldByName('BELEG_R').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
              FieldByName('KUNDE_R').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;
              FieldByName('BETRAG').AsDouble := -IB_Query1.FieldByName('DAVON_BEZAHLT').AsDouble;
              post;
              inc(_changed);
            end;

          end;

      end;

      next;
      if frequently(ShowTime, 444) or eof then
      begin
        ProgressBar1.Position := _read;
        application.processmessages;
        label2.caption := inttostr(_changed) + ' Änderungen';
      end;
    end;
  ProgressBar1.Position := 0;
  EndHourGlass;
end;

procedure TFormVersand.Button2Click(Sender: TObject);
var
  AllBelege: TStringList;
  AlleFehlNummern: TStringList;
  StartTime: dword;
begin
  BeginHourGlass;
  StartTime := 0;
  AllBelege := TStringList.create;
  AlleFehlNummern := TStringList.create;

  with IB_Query4 do
  begin
    Open;
    label1.caption := inttostr(RecordCount) + ' Belege ...';
    First;
    while not (eof) do
    begin
      AllBelege.Add(FieldByName('RID').AsString);
      next;
      if frequently(StartTime, 333) then
        application.ProcessMessages;
    end;
    close;
  end;
  AllBelege.sort;
  AllBelege.sorted := true;

  with IB_Query3 do
  begin
    Open;
    label3.caption := inttostr(RecordCount) + ' Posten ...';
    First;
    while not (eof) do
    begin
      if (AllBelege.IndexOf(FieldByName('BELEG_R').AsString) = -1) then
        AlleFehlNummern.add(FieldByName('RID').AsString + ',' + FieldByName('BELEG_R').AsString);
      next;
      if frequently(StartTime, 333) then
        application.ProcessMessages;
    end;
  end;
  AlleFehlNummern.SaveToFile(DiagnosePath + 'verlorene Beleg-Köpfe.txt');
  open(DiagnosePath + 'verlorene Beleg-Köpfe.txt');

  EndHourGlass;
  AllBelege.free;
  AlleFehlNummern.free;
end;

end.

