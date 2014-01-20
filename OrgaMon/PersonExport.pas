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
unit PersonExport;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_Components, IB_Access,
  ComCtrls, StdCtrls, Buttons;

type
  TFormPersonExport = class(TForm)
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    IB_Query3: TIB_Query;
    Label4: TLabel;
    CheckBox6: TCheckBox;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Label5: TLabel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    SpeedButton1: TSpeedButton;
    CheckBox3: TCheckBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    OLAPL: TSTringList;
  public
    { Public-Deklarationen }
    UserBreak: boolean;
    InsideExport: boolean;
  end;

var
  FormPersonExport: TFormPersonExport;

implementation

uses
  anfix32, globals, Funktionen.Beleg,
  IBExportTable, Datenbank, wanfix32;

{$R *.DFM}

procedure TFormPersonExport.Button1Click(Sender: TObject);
var
  StartTime: dword;
  ExportStrings: TStringList;
  DoppelteNamen: TStringList;
  DoppelteNamenInfo: TStringList;

  DoppelteNamenOrt: TStringList;
  DoppelteNamenInfoOrt: TStringList;
  KontaktSoll: TDateTime;

  MailingNein: TStringList;
  LandNein: TStringList;
  KontaktNein: TStringList;
  RechnungNein: TStringList;
  debugStrings: TStringList;

  // für Vorselektionen
  OKRIDS: TStringList;
  cPERSON: TIB_Cursor;

  OutStr: string;
  _Firma: string;
  _anrede: string;
  _Name: string;
  _strasse: string;
  _ort: string;
  RecordsByNow: integer;
  _lookat: integer;

  _nummer: string;
  _ansprache: string;
  _NachName: string;
  _MailingTrueSet: boolean;
  ErrorCount: integer;
  ExportPermission: boolean;
  n: integer;

  function NoSemi(const s: string): string;
  begin
    result := s;
    ersetze(';', ',', result);
  end;

  function btojn(b: boolean): string;
  begin
    if b then
      result := 'JA'
    else
      result := 'NEIN'
  end;

begin
  if InsideExport then
  begin
    UserBreak := true;
  end else
  begin
    BeginHourGlass;
    InsideExport := true;
    OKRIDS := nil;
    Button1.Caption := 'Abbruch';
    label3.caption := '';
    application.processmessages;

    if CheckBox3.Checked and assigned(OLAPL) then
    begin
      OKRIDS := OLAPL;
    end;

    if CheckBox6.checked then
    begin
      label2.caption := 'Abfrage auswerten ...';
      application.processmessages;
      OKRIDS := TStringList.create;

      cPERSON := DataModuleDatenbank.nCursor;
      with cPerson do
      begin
        sql.addstrings(memo1.lines);
        APiFirst;
        while not (eof) do
        begin
          OKRIDS.add(Fields[0].AsString);
          Apinext;
        end;
        close;
      end;
      cPERSON.free;

      OKRIDS.sort;
      OKRIDS.sorted := true;
      removeduplicates(OKRIDS);
      ShowMessage('Die Abfrage ergab ' + inttostr(OKRIDS.count) + ' Datensätze!');
    end;

    if CheckBox1.Checked then
      KontaktSoll := Long2dateTime(date2long(edit2.Text));

    ExportStrings := TStringList.create;
    MailingNein := TStringList.create;
    LandNein := TStringList.create;
    KontaktNein := TStringList.create;
    RechnungNein := TStringList.create;
    debugStrings := TStringList.create;

    DoppelteNamen := TStringList.create;
    DoppelteNamenInfo := TStringList.create;
    DoppelteNamenOrt := TStringList.create;
    DoppelteNamenInfoOrt := TStringList.create;
    UserBreak := false;
    StartTime := 0;
    RecordsByNow := 0;
    ErrorCount := 0;
    IB_Query1.Open;
    IB_Query2.Open;
    IB_Query3.Open;
    EnsureHourGlass;
    with IB_query1 do
    begin
      label1.caption := inttostr(RecordCount);
      progressbar1.position := 0;
      progressbar1.Max := RecordCount;
      first;
      while not (eof) do
      begin

        inc(RecordsByNow);
        _nummer := inttostr(FieldByName('NUMMER').AsInteger);
        _name := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);
        _NachName := FieldByName('NACHNAME').AsString;
        _lookat := FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
        _anrede := FieldByName('ANREDE').AsString;
        _MailingTrueSet := (FieldByName('MAILING').AsString = cC_True);
        _ansprache := FieldByName('ANSPRACHE').AsString;

        if (_ansprache = '') then
        begin

          // Versuche die Ansprache automatisch zu setzen
          repeat

            if (pos('Herr',_Anrede)=1) and (_NachName <> '') then
            begin
              _ansprache := 'Sehr geehrter Herr ' + _NachName;
              break;
            end;

            if (pos('Fr',_Anrede)=1) and (_NachName <> '') then
            begin
              _ansprache := 'Sehr geehrte Frau ' + _NachName;
              break;
            end;

            _ansprache := 'Liebe Musikfreunde'

          until true;
        end;

        // fetch the Adress-Block!
        IB_Query2.parambyname('CROSSREF').AsInteger := _lookat;

        if IB_Query2.IsEmpty then
        begin
          inc(ErrorCount);
        end else
        begin

          with IB_Query2 do
          begin
            _firma := FieldByName('NAME1').AsString;
            _strasse := FieldByName('STRASSE').AsString;
            _ort := FieldByName('ORT').AsString;

            if cutblank(_name) <> '' then
            begin
              DoppelteNamen.add(_name);
              DoppelteNamenOrt.add(_name + ' ' + _ort);
            end;

          end;

          Outstr := NoSemi(e_r_ort(IB_Query2)) + ';' +
            NoSemi(_Firma) + ';' +
            NoSemi(_anrede) + ';' +
            NoSemi(_Name) + ';' +
            NoSemi(_strasse) + ';' +
            _nummer + ';' +
            _Ansprache;

     // ************************************************************
     // hier Bedingungen prüfen
     // ************************************************************

          ExportPermission := true;
          repeat

            // SQL Selektion
            if assigned(OKRIDS) then
              if (OKRIDS.indexof(IB_query1.FieldByName('RID').AsString) = -1) then
              begin
                ExportPermission := false;
                break;
              end;

            // Mailing
            if CheckBox2.Checked then
              if not (_MailingTrueSet) then
              begin
                ExportPermission := false;
                MailingNein.add(OutStr);
              end;

            // Rechnungsempfänger
            if CheckBox4.Checked then
              if (IB_query1.FieldByName('RECHNUNGSEMPFAENGER').AsString = cC_True) then
              begin
                ExportPermission := false;
                RechnungNein.add(OutStr);
              end;

            // Kontakt
            if checkBox1.Checked then
            begin
              repeat

                // ANLAGE
                if IB_Query1.FieldByName('EINTRAG').AsDate >= KontaktSoll then
                  break;

                // ADRESSÄNDERUNG
                if not (IB_Query1.FieldByName('LETZTEAENDERUNG').IsNull) then
                  if IB_Query1.FieldByName('LETZTEAENDERUNG').AsDate >= KontaktSoll then
                    break;

                // VERKAUFSBELEG
                IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
                if not (IB_Query3.IsEmpty) then
                begin
                  DebugStrings.add('-' + IB_Query1.FieldByName('RID').AsString);
                  IB_Query3.first;
                  while not (IB_Query3.eof) do
                  begin
                    DebugStrings.add(IB_Query3.FieldByName('ANLAGE').AsString + ' ' +
                      btojn(IB_Query3.FieldByName('ANLAGE').AsDate >= KontaktSoll));
                    IB_Query3.next;
                  end;
                  IB_Query3.first;
                  if IB_Query3.FieldByName('ANLAGE').AsDate >= KontaktSoll then
                    break;
                end;

                ExportPermission := false;
                KontaktNein.Add(OutStr);
              until true;

            end;

          until true;

          if ExportPermission then
            ExportStrings.add(OutStr);

        end;
        next;
        if frequently(StartTime, 400) or eof then
        begin
          label2.caption := inttostr(RecordsByNow);
          label3.caption := inttostr(ExportStrings.count);
          progressbar1.position := RecordsByNow;
          application.processmessages;
          if Userbreak then
            break;
        end;
      end;
    end;

    IB_Query1.Close;
    IB_Query2.Close;
    IB_Query3.Close;


    ExportStrings.sort;
    ExportStrings.SaveToFile(MyProgramPath + 'Mailing\Adressen.txt');
    ExportStrings.free;

    MailingNein.sort;
    MailingNein.SaveToFile(MyProgramPath + 'Mailing\Aussortiert wegen Mailing.txt');
    MailingNein.free;

    LandNein.sort;
    LandNein.SaveToFile(MyProgramPath + 'Mailing\Aussortiert wegen Land.txt');
    LandNein.free;

    KontaktNein.Sort;
    KontaktNein.SaveToFile(MyProgramPath + 'Mailing\Aussortiert wegen Kontakt.txt');
    KontaktNein.free;

    RechnungNein.sort;
    RechnungNein.SaveToFile(MyProgramPath + 'Mailing\Aussortiert wegen Rechnungsempfänger.txt');
    RechnungNein.free;

    DoppelteNamen.sort;
    RemoveDuplicates(DoppelteNamen, n, DoppelteNamenInfo);

    DoppelteNamenInfo.SaveToFile(MyProgramPath + 'Mailing\DoppelteNamen.txt');

    DoppelteNamenOrt.sort;
    RemoveDuplicates(DoppelteNamenOrt, n, DoppelteNamenInfoOrt);

    DoppelteNamenInfoOrt.SaveToFile(MyProgramPath + 'Mailing\DoppelteNamenOrt.txt');

    debugStrings.Savetofile(MyProgramPath + 'Mailing\Diagnose.txt');
    debugStrings.free;

    DoppelteNamen.free;
    DoppelteNamenInfo.free;

    DoppelteNamenOrt.free;
    DoppelteNamenInfoOrt.free;

    progressbar1.position := 0;
    Button1.Caption := 'Start';

    EndHourGlass;
    InsideExport := false;

  end;
end;

procedure TFormPersonExport.Edit2Exit(Sender: TObject);
begin
  edit2.Text := long2date(date2long(edit2.text));
end;

procedure TFormPersonExport.FormCreate(Sender: TObject);
begin
  edit2.Text := long2date(DatePlus(DateGet, -370));
end;

procedure TFormPersonExport.Button2Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button3Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button4Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button5Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button6Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button7Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button8Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.Button9Click(Sender: TObject);
begin
  with Sender as TButton do
    openShell(MyProgramPath + 'Mailing\' + caption);
end;

procedure TFormPersonExport.CheckBox6Click(Sender: TObject);
begin
  memo1.enabled := CheckBox6.checked;
end;

procedure TFormPersonExport.SpeedButton1Click(Sender: TObject);
var
  n: integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    if not assigned(OLAPL) then
      OLAPL := TStringList.create;
    OLAPL.LoadFromFile(OpenDialog1.FileName);
    OLAPL.delete(0);
    for n := 0 to pred(OLAPL.count) do
      OLAPL[n] := nextp(OLAPL[n], cOLAPcsvSeparator, 0);
    EndHourGlass;
  end;
end;

end.

