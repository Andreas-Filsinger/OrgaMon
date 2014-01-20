(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit Datensammler;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Buttons, StdCtrls, VCLUnZip,
  VCLZip, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP,
  IdExplicitTLSClientServerBase;

type
  TForm1 = class(TForm)
    IdFTP1: TIdFTP;
    VCLZip1: TVCLZip;
    Button1: TButton;
    CheckBox1: TCheckBox;
    SpeedButton1: TSpeedButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    ComboBox1: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    SpeedButton2: TSpeedButton;
    Label23: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpeedButton9: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    { Private-Deklarationen }
    MyProgramPath: string;
    Subs: TStringList;
    Plausi: TStringList;

    function getZIPPassword: string;
  public
    { Public-Deklarationen }
    function NewTrn(IncrementIt: boolean = true): string;
    function KK20_Header: string;
    function shortenSerial(s: string): string;

    function FillFromSerial(SerialNo: string): boolean;
    procedure ShowComments;
    procedure FillCombo;
    procedure FillMemo(S: string);
    procedure generateSEWA(FName:string);
  end;

var
  Form1: TForm1;

implementation

uses
  IniFiles, anfix32, SolidFTP,
  html, WordIndex, globals;

{$R *.dfm}

const
  c_KK20_Sparte = 21;
  c_KK20_SerialNo = 46;
  c_KK20_ext_ui = 62;
  c_KK20_kombinat = 39;

  //
  c_KK21_bukrs = 1;
  c_KK21_ablbelnr = 2;
  c_KK21_pruefzahl = 3;
  c_KK21_zwtyp = 4;
  c_KK21_register = 5;

  //
  c_KK21_l_zstand = 14;
  c_KK21_erwstd_min = 21;
  c_KK21_erwstd_max = 22;
  c_KK21_kennzif = 23;
  c_KK21_massread = 26;
  c_KK21_resv2 = 28;

  cFirstTrn = '10000';
  cTrnFName = 'NonDa.TAN.ini';
  cNonda_Daten_FName = 'Daten.ini';
  cNonda_Ergebnis_FName = 'Ergebnis.ini';
  cNonDa_Pfade = 'NonDa.Pfade.ini';
  cNonDa_INfos_FName = 'NonDa.Infos.ini';
  cSource_FName = 'download sewa.txt';

  cNonDa_Settings_Lastprofile = 'Lastprofile';
  cNonDa_Settings_Auslesedaten = 'DatenVerzeichnisse';

  HourGlassLevel: integer = 0;

procedure BeginHourGlass;
begin
  if HourGlassLevel = 0 then
    screen.cursor := crHourGlass;
  inc(HourGlassLevel);
end;

procedure EnsureHourGlass;
begin
  if HourGlassLevel > 0 then
    screen.cursor := crHourGlass;
end;

procedure EndHourGlass;
begin
  dec(HourGlassLevel);
  if HourGlassLevel = 0 then
    screen.cursor := crdefault;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  MyIni: TiniFile;
  n: integer;
  AddFiles: TStringList;
  OnePath: string;
begin
  BeginHourGlass;
  memo1.Lines.clear;
  AddFiles := TStringList.create;
  MyIni := TiniFile.Create(MyProgramPath + cNonDa_Pfade);
  with MyIni do
  begin
    for n := 1 to 10 do
    begin
      OnePath := ReadString(cNonDa_Settings_Auslesedaten, inttostr(n), '');
      if (OnePath <> '') then
        if DirExists(ValidatePathName(OnePath)) then
          AddFiles.add(ValidatePathName(OnePath) + '\*')
        else
          Memo1.Lines.add('Fehler: Pfad "' + OnePath + '" existiert nicht!');

      OnePath := ReadString(cNonDa_Settings_Lastprofile, inttostr(n), '');
      if (OnePath <> '') then
        if DirExists(ValidatePathName(OnePath)) then
          AddFiles.add(ValidatePathName(OnePath) + '\*')
        else
          Memo1.Lines.add('Fehler: Pfad "' + OnePath + '" existiert nicht!');
    end;
  end;
  MyIni.free;
  EndHourGlass;

  // zip
  BeginHourGlass;
  with vclzip1 do
  begin
    Zipname :=
      MyProgramPath +
      ValidateFName(noblank(ComputerName)) + '.' +
      NewTrn +
      '.zip';
    FileDelete(Zipname);
    recurse := true;
    StorePaths := true;
    RelativePaths := false;
    RootDir := copy(MyProgramPath, 1, 3);
    FilesList.clear;
    FilesList.add(MyProgramPath + cNonda_Daten_FName);
    for n := 0 to pred(AddFiles.count) do
      FilesList.add(AddFiles[n]);
    PackLevel := 9;
    password := getZIPPassword;
    zip;
  end;
  AddFiles.Free;
  EndHourGlass;

  if CheckBox1.checked then
  begin

    // ftp-upload
    BeginHourGlass;
    with IdFTP1 do
    begin
      Host := 'orgamon.de';
      UserName := 'stadtwerke-singen';
      password := '7RDBQFYJP';
      passive := true;
    end;

    if not (SolidPut(IDFTP1, vclzip1.ZipName, '/', EXtractFileName(vclzip1.ZipName))) then
      Memo1.Lines.Add('Fehler: Upload war unmöglich!')
    else
      ShowMessage('Übertragung erfolgreich!');

    idFTP1.Disconnect;

    EndHourGlass;
  end else
  begin
   // Zip-Anzeigen!
    open(MyProgramPath);
  end;
end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Combobox1.Text := shortenSerial(Combobox1.Text);
    if FillFromSerial(ComboBox1.text) then
    begin
      ShowComments;
      Edit2.SetFocus;
    end;
    Key := #0;
  end;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  Myini: TiniFile;
  m: integer;
  MyTag: integer;
  LowerBound: double;
  HigherBound: double;
  TestValue: double;

begin
  if (Key = #13) then
  begin
    MyTag := -1;

    // aktuelle Eingabe speichern!
    Myini := TiniFile.Create(MyProgramPath + cNonDa_Daten_FName);
    with MyIni do
    begin
      for m := 0 to pred(ControlCount) do
        if (Controls[m].tag > 0) and (Controls[m] is TEdit) then
          with Controls[m] as TEdit do
          begin

            // Ist dies die aktuelle Eingabe?
            if Focused then
              MyTag := Tag;
            if (ReadString(ComboBox1.Text, inttostr(Tag), '') <> text) then
            begin
              WriteString(ComboBox1.Text,
                inttostr(Tag),
                text);
              WriteString(ComboBox1.Text,
                'Eingabedatum',
                Datum10);
              WriteString(ComboBox1.Text,
                'Eingabezeit',
                Uhr8
                );

            end;

            // Ist es plausibel?
            if (Tag <= Plausi.count) then
            begin
              try

                if (pos('..', Plausi[pred(Tag)]) > 0) and (Text <> '') then
                begin

                  LowerBound := strtodoubledef(nextp(Plausi[pred(Tag)], '..', 0), 0);
                  HigherBound := strtodoubledef(nextp(Plausi[pred(Tag)], '..', 1), 0);
                  TestValue := strtodoubledef(Text, 0);

                  if (TestValue >= LowerBound) and (TestValue <= HigherBound) then
                  begin
                    // Grüner Bereich
                    color := HTMLColor2TColor($CCFFCC);
                  end else
                  begin
                    // Über/Unter Schreitung
                    color := HTMLColor2TColor($FF9933);
                    beep;
                  end;

                end else
                begin
                  color := clWindow;
                end;

              except

              end;
            end;
          end;
    end;
    MyIni.free;
    Label23.Caption := '';
    // CheckPlausi


    // auf die nächste EIngabeposition fokusieren
    if (MyTag > 0) then
      for m := 0 to pred(ControlCount) do
        if (Controls[m].tag = MyTag + 1) and (Controls[m] is TEdit) then
          with Controls[m] as TEdit do
            SetFocus;

    Key := #0;
  end else
  begin
    Label23.Caption := 'Speichern mit <ENTER>!';
  end;

end;

procedure TForm1.generateSEWA(FName:string);
var
  FPath: string;
  OutS: TStringLisT;
  MySourceStrings: TStringList;
  n: integer;

  AbleseArten: TStringList;
  _AbleseArt: string;

  Sparten: TStringList;
  iSparte: integer;
  sSparte: string;

  MainLine: string;
  Zaehlwerk: integer;
  K20: TStringList;
  K21: TStringList;

  function BreakUp(const s: string): TStringList;
  var
    InpStr: string;
  begin
    result := TStringList.create;
    InpStr := s;
    while (InpStr <> '') do
      result.add(nextp(InpStr, ';'));
  end;

begin
  BeginHourGlass;

  AbleseArten := TStringList.create;
  Sparten := TStringList.create;
  OutS := TStringLisT.create;
  MySourceStrings := TStringList.create;

  FPath := ExtractFilePath(FName);
  OutS.add(KK20_header + ';Zaehlwerk;Art;Stand;Min;Max');
  ComboBox1.Items.clear;

  MySourceStrings.LoadFromFile(FName);
  for n := 0 to pred(MySourceStrings.count) do
  begin

    repeat

      if (pos('KK20', MySourceStrings[n]) = 1) then
      begin
        Zaehlwerk := 0;
        MainLine := MySourceStrings[n];
        break;
      end;

      if (pos('KK21', MySourceStrings[n]) = 1) then
      begin
        //
        inc(Zaehlwerk);
        K20 := BreakUp(MainLine);
        K21 := BreakUp(MySourceStrings[n]);

        //
        sSparte := K20[c_KK20_Sparte];
        iSparte := strtointdef(sSparte, -1);
        case iSparte of
          13:
            sSparte := 'Strom';
          23:
            sSparte := 'Gas';
          30:
            sSparte := 'Wasser';
          40:
            sSparte := 'Wärme';
        end;
        if (Sparten.indexof(sSparte) = -1) then
          Sparten.add(sSparte);

        _AbleseArt :=
          sSparte + ' ' +
          K21[c_KK21_zwtyp] + '.' +
          K21[c_KK21_register] + ' ' +
          K21[c_KK21_resv2] + ' [' +
          K21[c_KK21_massread] + ']';

        if AbleseArten.indexof(_Ableseart) = -1 then
          AbleseArten.add(_Ableseart);

        if (noblank(K21[c_KK21_erwstd_min]) = '') then
          K21[c_KK21_erwstd_min] := K21[c_KK21_l_zstand];

        if (noblank(K21[c_KK21_erwstd_max]) = '') then
          K21[c_KK21_erwstd_max] := K21[c_KK21_erwstd_min];

        Outs.add(
          MainLine +
          inttostr(Zaehlwerk) + ';' +
          _AbleseArt + ';' +
          K21[c_KK21_l_zstand] + ';' +
          K21[c_KK21_erwstd_min] + ';' +
          K21[c_KK21_erwstd_max]
          );
        K21.free;
        K20.free;
        break;
      end;
    until true;

  end;
  AbleseArten.sort;
  Sparten.sort;

  if (FPath=MyProgramPath) then
  begin
    OutS.SaveToFile(MyProgramPath + 'download sewa.csv');
    AbleseArten.SaveTofile(MyProgramPath + 'Ablesearten.txt');
    Sparten.SaveToFile(MyProgramPath + 'Sparten.txt');
  end else
  begin
    OutS.SaveToFile(FName+'.csv');
  end;

  OutS.Free;
  AbleseArten.free;
  Sparten.free;
  MySourceStrings.free;

  EndHourGlass;
end;

function TForm1.getZIPPassword: string;
begin
  if Radiobutton1.Checked then
    result := 'QHM9NBKZ8' // Singen
  else
    result := '934XY3E3P'; // Überlingen
end;

procedure TForm1.FillCombo;
var
  OutS: TStringLisT;
  MySourceStrings: TStringList;
  n: integer;
  ComboS: TStringList;
  Dubletten: integer;
  AbleseArten: TStringList;
  _AbleseArt: string;
  Dubs: TStringList;
begin
  Dubs := TStringList.create;
  AbleseArten := TStringList.create;
  ComboS := TStringList.create;
  OutS := TStringLisT.create;
  OutS.add(KK20_header);
  ComboBox1.Items.clear;
  MySourceStrings := TStringList.create;
  MySourceStrings.LoadFromFile(MyProgramPath + cSource_FName);
  for n := 0 to pred(MySourceStrings.count) do
  begin
    if (pos('KK20', MySourceStrings[n]) = 1) then
    begin
      ComboS.Add(
        shortenSerial(
        nextp(MySourceStrings[n], ';', c_KK20_SerialNo)));
      Outs.add(MySourceStrings[n]);
    end;

    if (pos('KK21', MySourceStrings[n]) = 1) then
    begin
      _AbleseArt :=
        nextp(MySourceStrings[n], ';', c_KK21_zwtyp) + '.' +
        nextp(MySourceStrings[n], ';', c_KK21_register) + ' ' +
        nextp(MySourceStrings[n], ';', c_KK21_resv2) + ' [' +
        nextp(MySourceStrings[n], ';', c_KK21_massread) + ']';
      if AbleseArten.indexof(_Ableseart) = -1 then
        AbleseArten.add(_Ableseart);
    end;

  end;
  MySourceStrings.free;
  OutS.SaveToFile(MyProgramPath + 'download sewa.csv');
  AbleseArten.sort;
  AbleseArten.SaveTofile(MyProgramPath + 'Ablesearten.txt');
  OutS.Free;
  ComboS.sort;
  RemoveDuplicates(ComboS, Dubletten, Dubs);
  Dubs.SaveToFile(MyProgramPath + 'Doppelte.txt');
  if (Dubletten > 0) then
    ShowMessage('ACHTUNG: Doppelte Zählernummern!' + #13 +
      'SEWA-EDV informieren!!');
  ComboBox1.Items.assign(ComboS);
  ComboS.free;
  Dubs.free;
end;

function TForm1.FillFromSerial(SerialNo: string): boolean;
var
  MySourceStrings: TStringList;
  n: integer;
  AutomataState: integer;
  TheComment: string;
begin
  result := false;
  MySourceStrings := TStringList.create;
  MySourceStrings.LoadFromFile(MyProgramPath + cSource_FName);
  AutomataState := 0;
  for n := 0 to pred(MySourceStrings.count) do
  begin
    case AutomataState of
      0:
      begin
          // suche der Kopf Datensatz
        if (pos('KK20', MySourceStrings[n]) = 1) then
        begin
            //
          if (
            shortenSerial(
            nextp(MySourceStrings[n], ';', c_KK20_SerialNo)) =
            combobox1.text) then
          begin
            FillMemo(MySourceStrings[n]);
            AutomataState := 1;
            Subs.Clear;
            plausi.Clear;
            result := true;
          end;
        end;
      end;
      1:
      begin

          // liste die Zählwerke auf!
        if (pos('KK21', MySourceStrings[n]) = 1) then
        begin
            //
          TheComment := nextp(MySourceStrings[n], ';', c_KK21_resv2) +
            ' [' + nextp(MySourceStrings[n], ';', c_KK21_massread) + ']';
          Subs.Add(TheComment);
          TheComment := noblank(nextp(MySourceStrings[n], ';', c_KK21_erwstd_min) +
            '..' + nextp(MySourceStrings[n], ';', c_KK21_erwstd_max));
          plausi.add(TheComment);
        end else
        begin
          break;
        end;
      end;
    end;
  end;
end;

procedure TForm1.FillMemo(s: string);

  function AsString(FieldName: string): string;
  var
    MyHeader: string;
    FieldID: integer;
  begin
    result := '<' + Fieldname + '?>';
    MyHeader := KK20_Header;
    FieldID := 0;
    while (MyHeader <> '') do
    begin
      if nextp(MyHeader, ';') = FieldName then
      begin
        result := nextp(s, ';', FieldID);
        break;
      end;
      inc(FieldID);
    end;
  end;

  function InfoPart(FieldName: string): string;
  begin
    result := FieldName + fill(' ', 20 - length(FieldName)) + ' : ' + AsString(FieldName);
  end;

var
  MyFields: tstringList;
  n: integer;
  TerminInfo: string;
begin
  TerminInfo := AsString('ausdat');
  label1.Caption :=
    'Termininfo ' +
    copy(TerminInfo, 1, 2) + '.' +
    copy(TerminInfo, 3, 2) + '.' +
    copy(TerminInfo, 5, 4);
  MyFields := tstringList.create;
  MyFields.LoadFromFile(MyProgramPath + cNonDa_Infos_FName);
  with memo1 do
  begin
    lines.clear;
    for n := 0 to pred(MyFields.count) do
      lines.add(InfoPart(MyFields[n]));
  end;
  MyFields.free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MyProgramPath := ExtractFilePath(application.exename);
  Subs := TStringList.create;
  Plausi := TStringList.create;
  caption :=
    'SEWA Datenkonzentrator ' +
    cMonatsCode +
    ' Rev. ' +
    RevToStr(Version);
  if not (IsParam('fastup')) then
    FillCombo;
end;

function TForm1.KK20_Header: string;
begin
  result := 'frmnam;bukrs;meterreadingunit;' +
    'vertrag;v_name1;v_name2;v_pstlz;v_ort01;v_stra;einzdat;' +
    'vbez;portion;abwann;street;hausnum;plz;city;vorname;nachname;' +
    'text;tariftyp;sparte;text30;tplnr;gp_pstlz;gp_ort;gp_stras;' +
    'gp_haus_num;gp_haus_alph;swerk;st_ktext;stortzus;hinweis;istablart;' +
    'gasdru;gastem;brwgeb;tempgeb;drugeb;kombinat;matnr;' +
    'herst_kz;ansjj;baujj;bgljahr;einbdat;sernr;equnr;herst;' +
    'besitz;lager;gangfolge;mrreason;ausdat;austim;usid;targetmrdate;' +
    'meterreader;maktx;preiskla;zwgruppe;kzwechsel;ext_ui;resv1;resv2;resv3;' +
    'resv4;resv5;resv6';
end;


function TForm1.shortenSerial(s: string): string;
begin
  result := s;
  while (pos('0', result) = 1) do
    delete(result, 1, 1);
end;

procedure TForm1.ShowComments;
var
  m: integer;
begin
  Label23.Caption := '';
  for m := 0 to pred(ControlCount) do
    if (Controls[m].tag > 0) then
    begin
      if (Controls[m] is TEdit) then
      begin
        with Controls[m] as TEdit do
        begin
          Text := '';
          color := clWindow;
        end;
      end;
      if (Controls[m] is TLabel) then
        with Controls[m] as TLabel do

          case Tag of
            1..10:
              if (tag <= Subs.count) then
                caption := Subs[pred(tag)]
              else
                caption := '- ohne Eingabe -';
            11..20:
              if (tag - 10 <= Plausi.count) then
                caption := Plausi[pred(tag - 10)]
              else
                caption := '';
          end;

      begin
      end;
    end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  FileAlive(MyProgramPath + cNonDa_Infos_FName);
  open(MyProgramPath + cNonDa_Infos_FName);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  FileAlive(MyProgramPath + cNonDa_Pfade);
  open(MyProgramPath + cNonDa_Pfade);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  Path: string;
  ErrorLog: TStringList;
  All_Iskra_Files: TStringList;
  SAP_Upload: TStringList;
  Zaehler_Werte: TStringList;
  n: integer;
  ResultINI: TIniFile;

  function CheckSet(ZaehlerNummer, Parameter, Wert: string): boolean;
  var
    _OldWert: string;
  begin
    if (ZaehlerNummer <> '') then
    begin
      try
        Wert := noblank(Wert);
        if (Parameter <> 'Eingabedatum') and (Parameter <> 'Eingabezeit') then
        begin
          if (pos('.', Wert) > 0) and (pos(',', Wert) > 0) then
            ErrorLog.add(ZaehlerNummer + ': Wert "' + Wert + '" ist nicht gültig');
          ersetze(',', '.', Wert);
          if StrFilter(Wert, '0123456789.') <> Wert then
            ErrorLog.add(ZaehlerNummer + ': Wert "' + Wert + '" ist nicht gültig');
        end;

        with ResultIni do
        begin
          _OldWert := ReadString(ZaehlerNummer, Parameter, '');
          if (_OldWert <> Wert) then
          begin
            if (_OldWert <> '') then
            begin
              result := false;
              ErrorLog.add(Zaehlernummer + ': Änderung von "' + _OldWert + '" auf "' + Wert + '"');
            end;
            WriteString(Zaehlernummer, parameter, wert);
          end;
        end;
      except
        on E: Exception do
        begin
          ErrorLog.add(ZaehlerNummer + ': Exception "' + E.Message);
        end;
      end;
    end;
  end;

  function proceedDRO(FName: string): TSTringList;
  var
    dro: TSearchStringList;
    Eingabedatum: string;
    Eingabezeit: string;
    SimpleMode: boolean;

    // Einzelwerte
    RS: string;
    ZAEHLER_NUMMER: string;

    function getVal(ParamName: string): string;
    var
      k: integer;
    begin
      repeat

        k := dro.FindInc(ParamName + '(');
        if (k <> -1) then
        begin
          result := ExtractSegmentBetween(dro[k], '(', ')');
          break;
        end;

        k := dro.FindInc('1-1:' + ParamName + '(');
        if (k <> -1) then
        begin
          result := ExtractSegmentBetween(dro[k], '(', ')');
          break;
        end;

        result := '';
      until true;
    end;

    procedure Map(SAP_Bezeichnung, DRO_Value: string);
    begin
      result.add(SAP_Bezeichnung + '=' + DRO_Value);
      CheckSet(Zaehler_Nummer, SAP_Bezeichnung, DRO_Value);
    end;

  var
    n: integer;

  begin
    //
    result := TStringList.Create;

    dro := TSearchStringList.create;
    dro.LoadFromFile(FName);
    for n := 0 to pred(dro.count) do
      dro[n] := noblank(dro[n]);

    SimpleMode := (dro.FindInc('00(') <> -1);
    if SimpleMode then
    begin
      ZAEHLER_NUMMER := getVal('00');
      if (ZAEHLER_NUMMER = '') then
      begin
        ErrorLog.add(FName + ': ZAEHLER_NUMMER nicht ermittelbar!');
      end else
      begin
        result.add('[' + ZAEHLER_NUMMER + ']');
        RS := getVal('01');
        Map('1.8.1*VV', getVal('09' + RS));
        Map('1.8.2*VV', getVal('08' + RS));
        Map('3.8.1*VV', getVal('49' + RS));
        Map('3.8.2*VV', getVal('48' + RS));
        Map('1.2.1', getVal('03'));
        Map('1.2.2', getVal('02'));
        Map('0.1.0', RS);
      end;
    end else
    begin
      ZAEHLER_NUMMER := getVal('0.0.0');
      if (ZAEHLER_NUMMER = '') then
      begin
        ErrorLog.add(FName + ': ZAEHLER_NUMMER nicht ermittelbar!');
      end else
      begin
        result.add('[' + ZAEHLER_NUMMER + ']');
        RS := getVal('0.1.0');
        Map('1.8.1*VV', getVal('1.8.2*' + RS));
        Map('1.8.2*VV', getVal('1.8.1*' + RS));
        Map('3.8.1*VV', getVal('3.8.2*' + RS));
        Map('3.8.2*VV', getVal('3.8.1*' + RS));
        Map('1.2.1', getVal('1.2.2'));
        Map('1.2.2', getVal('1.2.1'));
        Map('0.1.0', RS);
      end;
    end;

    result.add('Eingabedatum=' + long2date(FDate(FName)));
    CheckSet(Zaehler_Nummer, 'Eingabedatum', long2date(FDate(FName)));

    result.add('Eingabezeit=' + SecondstoStr(FSeconds(FName)));
    CheckSet(Zaehler_Nummer, 'Eingabezeit', SecondstoStr(FSeconds(FName)));

    dro.free;

  end;

  function ProceedINI(FName: string): TStringList;
  var
    ini: TStringList;
    n: integer;
    ZAEHLER_NUMMER: string;
  begin
    result := TStringList.create;
    ini := TStringList.create;
    ini.loadFromFile(FName);
    for n := 0 to pred(ini.count) do
    begin
      //
      if pos('[', ini[n]) = 1 then
      begin
        Zaehler_nummer := ExtractSegmentBetween(ini[n], '[', ']');

        CheckSet(Zaehler_Nummer, 'Eingabedatum', long2date(FDate(FName)));
        CheckSet(Zaehler_Nummer, 'Eingabezeit', SecondstoStr(FSeconds(FName)));

        result.add(ini[n]);
      end else
      begin
        if (pos('=', ini[n]) = 2) then
        begin
          CheckSet(Zaehler_Nummer, nextp(ini[n], '=', 0), nextp(ini[n], '=', 1));
          result.add(ini[n]);
        end;
      end;

    end;
    ini.free;
  end;

begin
  // Alle Eingabedaten zu einem Ergebnis vereinigen!
  Path := MyProgramPath + 'Tag1\';

  FileDelete(MyProgramPath + cNonda_Ergebnis_FName);

  ResultINI := TIniFile.create(MyProgramPath + cNonda_Ergebnis_FName);
  SAP_Upload := TStringList.create;
  All_Iskra_Files := TStringList.create;
  ErrorLog := TStringList.create;

  // Verarbeiten der dro - Daten!
  dir(Path + '*.dro', All_Iskra_Files, false);
  for n := 0 to pred(All_Iskra_Files.count) do
  begin
    Zaehler_Werte := proceedDRO(Path + All_Iskra_Files[n]);
    SAP_Upload.addstrings(Zaehler_Werte);
    Zaehler_Werte.Free;
  end;

  // Verarbeiten der manuellen Eingaben!
  dir(Path + 'Daten.*', All_Iskra_Files, false);
  All_Iskra_Files.sort;

  //
  for n := 0 to pred(All_Iskra_Files.count) do
  begin
    Zaehler_Werte := proceedINI(Path + All_Iskra_Files[n]);
    SAP_Upload.addstrings(Zaehler_Werte);
    Zaehler_Werte.Free;
  end;

  ErrorLog.SaveToFile(MyProgramPath + 'Error.Log.txt');
  SAP_Upload.SaveToFile(MyProgramPath + 'Upload-SEWA-SAP.txt');
  SAP_Upload.free;
  All_Iskra_Files.free;
  ResultINI.free;
  if (ErrorLog.count > 0) then
  begin
    open(MyProgramPath + 'Error.Log.txt');
  end else
  begin
    open(MyProgramPath + 'Upload-SEWA-SAP.txt');
  end;
  ErrorLog.Free;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  Ergebnis: TIniFile;
  SAP_Result: TStringList;
  SAP_Restanten: TStringList;
  MySourceStrings: TStringList;
  ErrorLog: TStringList;
  n: integer;
  K21_count: integer;

  Stat_ergebnisse: integer;
  Stat_Restanten: integer;
  Stat_Zaehler: integer;

  // Zwischenwerte
  Zaehler_Nummer: string;
  Zaehler_Stand: string;
  EingabeDatum: string;
  EingabeUhr: string;
  ext_ui: string;
  kombinat: string;

  SAPmapping: string;

  // Plausibilität
  LowerBound: double;
  HigherBound: double;
  LetzterStand: double;
  ZaehlerStand: double;

  _lowerBound: string;
  _HigherBound: string;
  _letzterStand: string;
  kennzif: string;

  function Format_ZaehlerNummer(z: string): string;
  begin
    result := fill('0', 10 - length(z)) + z;
  end;

  function Format_ZaehlerStand(s: string): string;
  begin
    if (K21_count = 7) then
      result := noblank(s)
    else
      result := fill(' ', 12 - length(s)) + s;
  end;

  function Format_Eingabedatum(s: string): string;
  begin
    result := copy(s, 1, 2) +
      copy(s, 4, 2) +
      copy(s, 7, 4);
  end;

  function Format_Eingabezeit(s: string): string;
  begin
    result := copy(s, 1, 2) + copy(s, 4, 2);
  end;

begin

  //
  Stat_Ergebnisse := 0;
  Stat_Restanten := 0;
  Stat_zaehler := 0;

  //
  Ergebnis := TIniFile.Create(MyProgramPath + cNonda_Ergebnis_FName);
  SAP_Result := TStringList.create;
  SAP_Restanten := TStringList.create;
  SAP_Restanten.add(KK20_Header);

  MySourceStrings := TStringList.create;
  ErrorLog := TStringList.Create;
  MySourceStrings.LoadFromFile(MyProgramPath + cSource_FName);
  Zaehler_Nummer := '';
  for n := 0 to pred(MySourceStrings.count) do
  begin

    // suche der Kopf Datensatz
    if (pos('KK20', MySourceStrings[n]) = 1) then
    begin
      inc(Stat_Zaehler);

      //
      Zaehler_Nummer := shortenSerial(
        nextp(MySourceStrings[n], ';', c_KK20_SerialNo));

      if (Ergebnis.ReadString(Zaehler_nummer, 'Eingabedatum', '') <> '') then
      begin
        EingabeDatum := Ergebnis.ReadString(Zaehler_nummer, 'Eingabedatum', '');
        EingabeUhr := Ergebnis.ReadString(Zaehler_nummer, 'Eingabezeit', '');
        ext_ui := nextp(MySourceStrings[n], ';', c_KK20_ext_ui);
        kombinat := nextp(MySourceStrings[n], ';', c_KK20_kombinat);
        inc(Stat_Ergebnisse);
        K21_count := 1;
      end else
      begin
        SAP_Restanten.add(MySourceStrings[n]);
        inc(Stat_restanten);
        if (Stat_Restanten > 0) then
          ErrorLog.add('3.Rest;' + Zaehler_Nummer + ';*;Restant #' +
            inttostr(Stat_restanten)
            );
        Zaehler_Nummer := '';
      end;
    end;

    // liste die Zählwerke auf!
    if (pos('KK21', MySourceStrings[n]) = 1) and (Zaehler_nummer <> '') then
    begin

      // jetzt kommen einzelne Zeilen!
      kennzif := nextp(MySourceStrings[n], ';', c_KK21_kennzif);
      SAPmapping := nextp(kennzif, ':', 1);
      if (SAPmapping='') then
      begin
        ErrorLog.add(
          '0.Panic;' +
          Zaehler_Nummer + ';' +
          kennzif +
          ';Keine Kennziffer vorhanden!');
        continue;
      end;
      _LowerBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_min);
      LowerBound := strtodoubledef(_LowerBound, -1);
      _HigherBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_max);
      HigherBound := strtodoubledef(_HigherBound, -1);
      _LetzterStand := nextp(MySourceStrings[n], ';', c_KK21_l_zstand);
      LetzterStand := strtodoubledef(_letzterStand, -1);

      // zunächst aus MDE erfassung versuchen
      Zaehler_stand := Ergebnis.ReadString(zaehler_nummer, SAPmapping, '');
      if (Zaehler_stand = '') then
      begin
        // nun aus der manuellen Erfaasung versuchen
        SAPmapping := inttostr(K21_count);
        Zaehler_stand := Ergebnis.ReadString(zaehler_nummer, SAPmapping, '');
      end;

      if (Zaehler_stand = '') then
      begin
        ErrorLog.add('0.Panic;' + Zaehler_Nummer + ';' +
          kennzif +
          ';Stand ist leer (=' +
          _letzterSTand + ',<' +
          _lowerBound + ',>' +
          _HigherBound + ')');
      end else
      begin

      // Plausibilitätsnachricht!
        try
          repeat


            ZaehlerStand := strtodoubledef(Zaehler_stand, -1);
            if (ZaehlerStand >= 0) then
            begin

              if (LetzterStand > 0) then
              begin

                if (LetzterStand = ZaehlerStand) then
                begin
                  ErrorLog.add('2.Info;' + Zaehler_Nummer + ';' + kennzif + ';kein Verbrauch (' +
                    Zaehler_Stand + '=' + _LetzterStand + ')');
                  break;
                end;

                if (ZaehlerStand < LetzterStand) then
                begin
                  ErrorLog.Add('0.Panic;' + Zaehler_Nummer + ';' + kennzif + ';geringer als letzter Stand (' +
                    Zaehler_Stand + '<' + _letzterStand + ')');
                  break;
                end;
              end;

              if (LowerBound > 0) then
                if (ZaehlerStand < LowerBound) then
                  ErrorLog.add('1.Warn;' + Zaehler_Nummer + ';' + kennzif + ';Unterschreitung der Untergenze (' +
                    ZAehler_stand + '<' + _LowerBound + ')');

              if (HigherBound > 0) and (HigherBound > LowerBound) then
                if (ZaehlerStand > HigherBound) then
                  ErrorLog.Add('1.Warn;' + Zaehler_Nummer + ';' + kennzif + ';Überschreitung der Obergrenze (' +
                    Zaehler_Stand + '>' + _HigherBound + ')');

            end else
            begin
              ErrorLog.Add('0.Panic;' +
                Zaehler_Nummer + ';' +
                kennzif + ';Stand "' +
                ZAehler_Stand + '" ist keine Zahl!');
            end;

          until true;
        except

        end;

        SAP_Result.add(
          'KK22;' +
          nextp(MySourceStrings[n], ';', c_KK21_bukrs) + ';' +
          nextp(MySourceStrings[n], ';', c_KK21_ablbelnr) + ';' +
          nextp(MySourceStrings[n], ';', c_KK21_pruefzahl) + ';' +
          ext_ui + ';' +
          kennzif + ';' +
          nextp(MySourceStrings[n], ';', c_KK21_register) + ';' +
          kombinat + ';' +
          format_zaehlerNummer(Zaehler_Nummer) + ';' +
          Format_Eingabedatum(Eingabedatum) + ';' +
          ';' +
          Format_Eingabezeit(EingabeUhr) + ';' +
          ';' +
          format_zaehlerstand(Zaehler_Stand) + ';' +
          ';' +
          '101;' +
          '01'
          );

      end;

      inc(K21_count);
    end;

  end;
  if (Stat_Restanten > 0) then
    ErrorLog.add('0.Panic;*;*;' + inttostr(Stat_restanten) + ' Restanten bei ' + inttostr(Stat_zaehler));
  ErrorLog.Sort;


  ErrorLog.SaveToFile(
    MyProgramPath + 'SEWA-Plausibilität-' + cMonatsCode + '.csv');
  SAP_Result.SaveToFile(
    MyProgramPath + 'SEWA-Upload-' + cMonatsCode + '.txt');
  SAP_Restanten.SaveToFile(
    MyPRogramPath + 'SEWA-Restanten-' + cMonatsCode + '.csv');

  // Rohdaten
  with vclzip1 do
  begin
    Zipname :=
      MyProgramPath +
      'SEWA-Rohdaten-' + cMonatsCode + '.zip';
    FileDelete(Zipname);
    recurse := false;
    StorePaths := false;
    RelativePaths := false;
    RootDir := '';
    FilesList.clear;
    FilesList.add(MyPRogramPath + 'Tag1\*');
    PackLevel := 9;
    password := getZipPassword;
    zip;
  end;

  // upload
  with vclzip1 do
  begin
    Zipname :=
      MyProgramPath +
      'SEWA-Upload-' + cMonatsCode + '.zip';
    FileDelete(Zipname);
    recurse := false;
    StorePaths := false;
    RelativePaths := false;
    RootDir := '';
    FilesList.clear;
    FilesList.add(
      MyPRogramPath + 'SEWA-Plausibilität-' + cMonatsCode + '.csv');
    FilesList.add(
      MyPRogramPath + 'SEWA-Restanten-' + cMonatsCode + '.csv');
    FilesList.add(
      MyProgramPath + 'SEWA-Upload-' + cMonatsCode + '.txt');
    FilesList.add(
      MyProgramPath + 'SEWA-Rohdaten-' + cMonatsCode + '.zip');
//    FilesList.add(
//      MyPRogramPAth + 'SEWA-Restanten-' + MonatsCode + '.csv');
    PackLevel := 9;
    password := getZipPassword;
    zip;
  end;

  // Rohdaten wieder löschen!
  FileDelete(MyProgramPath +
    'SEWA-Rohdaten-' + cMonatsCode + '.zip');

  // LastProfile
  with vclzip1 do
  begin
    Zipname :=
      MyProgramPath +
      'SEWA-Lastprofile-' + cMonatsCode + '.zip';
    FileDelete(Zipname);
    recurse := false;
    StorePaths := false;
    RelativePaths := false;
    RootDir := '';
    FilesList.clear;
    FilesList.add(MyPRogramPath + 'Lastprofile\*');
    PackLevel := 9;
    password := getZIPPassword;
    zip;
  end;

  //
  if (ErrorLog.Count > 0) then
    open(MyProgramPath + 'SEWA-Plausibilität-' + cMonatsCode + '.csv')
  else
    open(MyProgramPath + 'SEWA-Upload-' + cMonatsCode + '.txt');

  ErrorLog.Free;
  SAP_Restanten.free;
  SAP_Result.Free;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
var
  AllLPs: TStringList;

  procedure readSources;
  var
    MyIni: TiniFile;
    n, m: integer;
    OnePath: string;
    DirList: TStringList;
  begin
    BeginHourGlass;
    MyIni := TiniFile.Create(MyProgramPath + cNonDa_Pfade);
    with MyIni do
    begin
      for n := 1 to 10 do
      begin
        OnePath := ReadString(cNonDa_Settings_Lastprofile, inttostr(n), '');
        if (OnePath <> '') then
        begin
          OnePath := ValidatePathName(OnePath);
          if DirExists(OnePath) then
          begin
            DirList := TStringList.create;
            dir(ValidatePathName(OnePath) + '\*.lp', DirList, false, false);
            for m := 0 to pred(DirList.Count) do
              AllLPs.add(OnePath + '\' + DirList[m]);
            DirList.Free;
          end else
          begin
            Memo1.Lines.add('Fehler: Pfad "' + OnePath + '" existiert nicht!');
          end;
        end;
      end;
    end;
    MyIni.free;
    EndHourGlass;
  end;

  procedure convertOne(FName: string);
  const
    cStartTag = 'P.01';

  var
    Thelp: TStringList;
    Thecsv: TStringList;
    Parameters: TStringList;

    lpDate: TAnfixDate;
    lpTime: TAnfixTime;
    lpMode: string;
    lpTimerInterVal: TAnfixTime;

    lpDimensions: integer;

    AutoMataState: integer;
    OneLine: string;
    IDLine: string;

    procedure fillParameters(s: string);
    var
      k, n: integer;

      function asString(p: string): string;
      begin
        result := p;
        ersetze('.', ',', result);
      end;

    begin
      Parameters.clear;
      repeat
        k := pos('(', s);
        n := pos(')', s);
        if (k > 0) and (n > k) then
        begin
          Parameters.add(
            asString(
            copy(
            s, k + 1, (n - k) - 1)));
          delete(s, 1, n);
        end else
          break;
      until false;
    end;

  var
    n: integer;

  begin
    Parameters := TStringList.create;
    TheLP := TStringList.create;
    TheCSV := TStringList.create;
    IDLine := '?';
    try

      TheLP.LoadFromFile(FName);

    //
      AutoMataState := 0;
      for n := 0 to pred(TheLP.count) do
      begin

        OneLine := cutblank(TheLP[n]);
        if (OneLine = '') then
          continue;

        case AutoMataState of
          0:
          begin
            if (pos('#',OneLine)=1) then
              IDLine := OneLine;

            if (pos(cStartTag, OneLine) = 1) then
              inc(AutoMataState);
          end;
          1:
          begin
           // 0601010015
            OneLine := ExtractSegmentBetween(OneLine, '(', ')');
            lpDate := Date2long(
              copy(OneLine, 5, 2) + '.' +
              copy(OneLine, 3, 2) + '.' +
              copy(OneLine, 1, 2));

            lpTime := strtoseconds(
              copy(OneLine, 7, 2) + ':' +
              copy(OneLine, 9, 2) + ':00');
            inc(AutoMataState);

          end;
          2:
          begin
            lpMode := ExtractSegmentBetween(OneLine, '(', ')');
            if lpMode = '10' then
              lpMode := lpMode + ', Rückstellung';

            inc(AutoMataState);
          end;
          3:
          begin
            lpTimerInterVal := strtoint(ExtractSegmentBetween(OneLine, '(', ')')) * 60;
            inc(AutoMataState);
          end;
          4:
          begin
            lpDimensions := strtointdef(ExtractSegmentBetween(OneLine, '(', ')'), 0) * 2;
            inc(AutoMataState);

          end;
          5:
          begin
            dec(lpDimensions);
            if lpDimensions = 0 then
              inc(AutoMataState);

          end;
          6:
          begin
            // Data
            if (pos(cStartTag, OneLine) = 1) then
            begin
              AutoMataState := 1;
            end else
            begin
              fillParameters(OneLine);

              TheCSV.add(
                long2date(lpDate) + ' ' + secondstoStr8(lpTime) + ';' +
                lpMode + ';' +
                Parameters[0] + ';' +
                Parameters[1]);

              // Zeit voranschreiben
              SecondsAddLong(lpDate, lpTime, lpTimerInterval, lpDate, lpTime);

            end;
          end;

        end;
      end;
      TheCSV.SaveToFile(Fname + '.csv');
    except
      on E: Exception do
      begin
        ShowMessage(FName + ': ' + IDLine +#13+ e.Message);
      end;

    end;

    Parameters.free;
    TheLP.free;
    TheCSV.free;

  end;

var
  n: integer;

begin
  // Im ISKRA-Verzeichnis alle lp Daten kovertieren!
  Memo1.lines.clear;

  AllLPs := TStringList.create;

  // erst mal alle Quellen sammeln!
  readSources;

  for n := 0 to pred(AllLPs.Count) do
    convertOne(AllLPs[n]);


end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
var
  MyIni: TiniFile;
  n: integer;
  OnePath: string;
begin
  if DoIt('ACHTUNG!' + #13 +
    'Diese Funktion wird nur für den Monatsabschluss ' + #13 +
    'benötigt! Sind alle Daten übertragen?' + #13 +
    'Sind alle Daten an den Versorger übertragen?' + #13 +
    'Wollen Sie jetzt mit einer neuen Ablesung beginnen?' + #13 +
    'Dürfen alle bisherigen Eingaben GELÖSCHT werden') then
  begin

    // manuelle Eingaben
    FileDelete(MyProgramPath + cNonda_Daten_FName);

    // Auslesung und Lastprofile
    MyIni := TiniFile.Create(MyProgramPath + cNonDa_Pfade);
    with MyIni do
    begin
      for n := 1 to 10 do
      begin

        OnePath := ReadString(cNonDa_Settings_Auslesedaten, inttostr(n), '');
        if (OnePath <> '') then
          if DirExists(ValidatePathName(OnePath)) then
            FileDelete(ValidatePathName(OnePath) + '\*');

        OnePath := ReadString(cNonDa_Settings_Lastprofile, inttostr(n), '');
        if (OnePath <> '') then
          if DirExists(ValidatePathName(OnePath)) then
            FileDelete(ValidatePathName(OnePath) + '\*');
      end;
    end;
    MyIni.free;

  end;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
var
  Path: string;
  MyIni: TIniFile;
  AbleseDatumMitte: integer;
  AbleseDatum: integer;
  MySourceStrings: TStringList;
  Zaehler_Nummer: string;
  n: integer;
  Zaehlwerk: integer;

  //
  _LowerBound: string;
  LowerBound: double;
  _HigherBound: string;
  HigherBound: double;
  _LetzterStand: string;
  LetzterStand: double;

  //
  AblesewertVarianz: double;
  AbleseWert: integer;

  function RandomDiff: integer;
  const
    cAbleseDatumVarianz = 15;
  begin
    result := cAbleseDatumVarianz - random((cAbleseDatumVarianz * 2) + 1);
  end;

begin
  // Für alle Zähler zufällige Ablesewerte ausgeben!
  AbleseDatumMitte := date2long('15.09.2006');

  Path := MyProgramPath + 'Tag1\';

  MySourceStrings := TStringList.create;
  Myini := TiniFile.Create(Path + cNonDa_Daten_FName);
  with MyIni do
  begin
    MySourceStrings.LoadFromFile(MyProgramPath + cSource_FName);
    Zaehler_Nummer := '';
    for n := 0 to pred(MySourceStrings.count) do
    begin

      // suche der Kopf Datensatz
      if (pos('KK20', MySourceStrings[n]) = 1) then
      begin

        //
        Zaehler_Nummer := shortenSerial(
          nextp(MySourceStrings[n], ';', c_KK20_SerialNo));
        Zaehlwerk := 0;
      end;

      // liste die Zählwerke auf!
      if (pos('KK21', MySourceStrings[n]) = 1) and (Zaehler_nummer <> '') then
      begin
        inc(Zaehlwerk);

        // jetzt kommen einzelne Zeilen!
        _LowerBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_min);
        LowerBound := strtodoubledef(_LowerBound, -1);
        _HigherBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_max);
        HigherBound := strtodoubledef(_HigherBound, -1);
        _LetzterStand := nextp(MySourceStrings[n], ';', c_KK21_l_zstand);
        LetzterStand := strtodoubledef(_letzterStand, -1);

        AblesewertVarianz := HigherBound - LowerBound;

        repeat

          if (LowerBound = -1) or (HigherBound = -1) then
          begin
          // freie Auswahl
            AbleseWert := random(1000000);
            break;
          end;

          if (LowerBound = HigherBound) then
          begin
            AbleseWert := round(HigherBound);
          end;

          AbleseWert := round(LowerBound + random(trunc(AblesewertVarianz)));

        until true;

        AbleseDatum :=
          DatePlus(AbleseDatumMitte, RandomDiff);

        WriteString(Zaehler_nummer,
          inttostr(Zaehlwerk),
          inttostr(Ablesewert));

        if (Zaehlwerk = 1) then
        begin
          WriteString(
            Zaehler_nummer,
            'Eingabedatum',
            long2date(AbleseDatum));

          WriteString(
            Zaehler_nummer,
            'Eingabezeit',
            Uhr8
            );

        end;
      end;
    end;

  end;
  MyIni.free;
  MySourceStrings.free;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  generateSEWA(MyProgramPath + cSource_FName);
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
var
  FName : string;
  WorkPath : string;
  sFiles: TStringList;
  n : integer;

  procedure EnsureEXPORT(FName:string);
  var
   sName : string;
   sPath : string;
  begin
   sName := ExtractFileName(FName);
   if pos('EXPORT-',sName)=0 then
   begin
    sPath := ExtractFilePath(Fname);
    FileMove(FName,sPath+'EXPORT-'+sName);
   end;
  end;

begin
  with OpenDialog1 do
  begin
    sFiles := TStringList.create;
    InitialDir := MyProgramPath;
    if Execute then
    begin
      FName :=  FileName;
      if (FName<>'') then
        if FileExists(FName) then
        begin

          generateSEWA(FName);
          EnsureEXPORT(FName);


          WorkPath := ExtractFilePath(FName);
          dir(WorkPath+'*.txt',sFiles,false);
          if (sFiles.count>1) then
          begin
            if doit(
              'Jetzt sicherstellen, dass alle ' +
              inttostr(sFiles.count) +
              ' konvertiert sind') then
            begin

              for n := 0 to pred(sFiles.count) do
                if not(FileExists(WorkPath+sFiles[n]+'.csv')) then
                begin
                  generateSEWA(WorkPath+sFiles[n]);
                    EnsureEXPORT(WorkPath+sFiles[n]);
                end;

            end;
          end;
        end;
    end;
    sFiles.free;
  end;
end;

function TForm1.NewTrn(IncrementIt: boolean = true): string;
var
  TrnFile: TextFile;
  TrnLine: string;
begin

  // load
  if not (FileExists(MyProgramPath + cTrnFName)) then
  begin
    TrnLine := cFirstTrn;
  end else
  begin
    AssignFile(TrnFile, MyProgramPath + cTrnFName);
    reset(TrnFile);
    readln(TrnFile, TrnLine);
    closeFile(TrnFile);
  end;
  result := TrnLine;

  //
  if IncrementIt then
  begin

    // save next number!
    TrnLine := inttostr(succ(strtoint(TrnLine)));
    AssignFile(TrnFile, MyProgramPath + cTrnFName);
    rewrite(TrnFile);
    writeln(TrnFile, TrnLine);
    closeFile(TrnFile);
  end else
  begin
  end;

end;


end.

