{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2023  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
unit OLAP;
//
// Never ask me, ask OLAP
//
{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, JvGIF,
  ExtCtrls, SynEditHighlighter, SynHighlighterSQL,

  SynEdit, SynMemo,

  // FlexCell
  VCL.FlexCel.Core, FlexCel.xlsAdapter,
  IB_Components,
  IB_Header, IB_Grid, gplists,
  Buttons, basic;

type
  TFormOLAP = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    Image2: TImage;
    SynMemo1: TSynMemo;
    SynSQLSyn1: TSynSQLSyn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;

    procedure ReFreshFileList;
    function DefaultFName: string;
  public

    { Public-Deklarationen }
    DataBaseChosen: integer;

    // UI
    function UserInput(Line: string): string;

    // Haupt - Auswerte Funktionen
    procedure DoContextOLAP(g: TIB_Grid; Variante: string = ''); overload;
    procedure DoContextOLAP(FileMask:string; GlobalVars: TStringList = nil); overload;

  end;

var
  FormOLAP: TFormOLAP;

  // Faulenzer:
procedure DoContextOLAP(g: TIB_Grid);

implementation

uses

  // Delphi
  math,

  // IBO
  IB_Session,

  // Tools
  anfix, dbOrgaMon, WordIndex,
  CareTakerClient, ExcelHelper, html,
  Geld, OpenOfficePDF,
  wanfix,

  // OrgaMon-Core
  globals, Datenbank,
  Funktionen_OLAP,
  Funktionen_Basis,
  Funktionen_Auftrag,
  Funktionen_Beleg,
  Funktionen_Buch,

  // OrgaMon-VCL
  ArtikelVerlag, Einstellungen, AuftragArbeitsplatz,
  GUIHelp, DruckSpooler, Auswertung, Bearbeiter;

{$R *.dfm}

function FeedBack (key : Integer; value : string = '') : Integer;
begin
  result := cFeedBack_CONT;
  with FormOLAP do
  begin
    case Key of
     cFeedBack_ProcessMessages: Application.Processmessages;
     cFeedBack_ProgressBar_Max+1: progressbar1.max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Position+1: progressbar1.position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit+1: progressbar1.StepIt;
     cFeedBack_Label+4: label4.caption := value;
     cFeedBack_OpenShell: openShell(value);
     cFeedBack_Function+1: if not(pDisableDrucker) then
                             printhtmlok(value);
     cFeedBack_Function+2: if not(pDisableDrucker) then
                             printShell(value);
     cFeedBack_Function+3: UserInput(value);
     cFeedBack_ShowMessage: ShowMessage(value);
    else
     ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
    end;
  end;
end;

function TFormOLAP.DefaultFName: string;
begin
  result := iOlapPath + 'default' + cOLAPExtension;
end;

procedure TFormOLAP.FormActivate(Sender: TObject);
begin
  if not(Initialized) then
  begin
    Label2.caption := 'Ihr persönliches OLAP Verzeichnis : ' + iOlapPath;
    CheckCreateDir(iOlapPath);
    if FileExists(DefaultFName) then
      SynMemo1.lines.loadfromFile(DefaultFName);
    ComboBox1.text := ExtractFileName(DefaultFName);
    SaveDialog1.DefaultExt := cOLAPExtension + '|' + 'OLAP Definitions Script';
    Initialized := true;
  end;
  ReFreshFileList;
end;

procedure TFormOLAP.Button1Click(Sender: TObject);
begin
  SaveDialog1.FileName := iOlapPath + ComboBox1.text;
  if SaveDialog1.Execute then
  begin
    ComboBox1.text := ExtractFileName(SaveDialog1.FileName);
    SynMemo1.lines.savetofile(SaveDialog1.FileName);
    ReFreshFileList;
  end;
end;

procedure TFormOLAP.ReFreshFileList;
var
  AllOLAPs: TStringList;
begin
  AllOLAPs := TStringList.create;
  dir(iOlapPath + '*' + cOLAPExtension, AllOLAPs, false);
  AllOLAPs.sort;
  ComboBox1.items.assign(AllOLAPs);
  AllOLAPs.free;
end;

procedure TFormOLAP.Button2Click(Sender: TObject);
var
 GlobalVars: TStringList;
begin
  // save
  SynMemo1.lines.savetofile(iOlapPath + ComboBox1.text);

  // execute
  GlobalVars := TStringList.Create;
  GlobalVars.Add('$Silent='+cIni_Deactivate);
  e_x_OLAP(iOlapPath + ComboBox1.text, GlobalVars, FeedBack);
  GlobalVars.Free;
end;

procedure TFormOLAP.ComboBox1Select(Sender: TObject);
begin
  SynMemo1.lines.loadfromFile(iOlapPath + ComboBox1.text);
end;

procedure TFormOLAP.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'OLAP');
end;

procedure TFormOLAP.SpeedButton1Click(Sender: TObject);
begin
  openShell(iOlapPath);
end;

procedure TFormOLAP.SpeedButton2Click(Sender: TObject);
begin
  openShell(AnwenderPath);
end;

procedure TFormOLAP.SpeedButton3Click(Sender: TObject);
begin
  SynMemo1.lines.savetofile(iOlapPath + ComboBox1.text);
end;

procedure TFormOLAP.SpeedButton4Click(Sender: TObject);
begin
  openShell(iSystemOlapPath);
end;

procedure TFormOLAP.DoContextOLAP(g: TIB_Grid; Variante: string = '');
var
  FName: string;
  n: integer;
  ParameterL : TStringList;
begin
  try
    FName := iOlapPath + GridSettingsIdentifier(g) + Variante + cOLAPExtension;

    if FileExists(FName) then
    begin
      ParameterL := TStringList.create;
      repeat
        //
        if bnBilligung('OLAP:' + nextp(ExtractFileName(FName), cOLAPExtension, 0)) then
          break;


        //
        with g.DataSource.Dataset do
        begin
          for n := 0 to pred(FieldCount) do
            with Fields[n] do
            begin
              if IsNull then
              begin
                ParameterL.add('$' + FieldName + '=null');
              end
              else
              begin
                case SQLType of
                  SQL_DOUBLE, SQL_DOUBLE_, SQL_INT64, SQL_INT64_, SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_,
                    SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_, SQL_TIMESTAMP, SQL_TIMESTAMP_, SQL_TYPE_DATE,
                    SQL_TYPE_DATE_:
                    begin
                      ParameterL.add('$' + FieldName + '=' + AsString);
                    end;
                end;
              end;
            end;
        end;

        // Ausführen
        e_x_OLAP(FName, ParameterL, FeedBack);
      until yet;
      ParameterL.Free;
    end
    else
    begin
      ShowMessage(FName);
    end;
  except
  end;
end;

procedure TFormOLAP.DoContextOLAP(FileMask:string; GlobalVars: TStringList = nil);
var
  sOLAPs: TStringList;
  n: integer;
begin
  if (StrFilter(FileMask, '*?') = '') then
  begin

    repeat

      if bnBilligung('OLAP:' + nextp(ExtractFileName(FileMask), cOLAPExtension, 0)) then
        break;

      // Liste der Globales Variable aufbauen!
      e_x_OLAP(FileMask, GlobalVars, FeedBack);

    until yet;

  end
  else
  begin
    sOLAPs := TStringList.create;
    dir(FileMask, sOLAPs, false);
    for n := 0 to pred(sOLAPs.count) do
      DoContextOLAP(ExtractFilePath(FileMask) + sOLAPs[n], GlobalVars);
    sOLAPs.free;
  end;
end;

procedure DoContextOLAP(g: TIB_Grid);
begin
  FormOLAP.DoContextOLAP(g);
end;

function TFormOLAP.UserInput(Line: string): string;
var
  DynForm: TForm;
  AskLabel: TLabel;
  AskSelect: TComboBox;
  DimensionValues: TStringList;
  n: integer;
  ExecuteStatement: string;
begin
  result := Line;
  repeat
    if (pos('=?', Line) > 0) then
    begin

      // Vor dem Eingabe Feld!
      AskLabel := TLabel.create(nil);
      with AskLabel do
      begin
        top := 10;
        left := 10;
        caption := nextp(nextp(Line, '=?', 1), 'from', 0);
      end;

      // Das Eingabfeld
      AskSelect := TComboBox.create(nil);
      with AskSelect do
      begin
        top := 10;
        left := 150;
      end;

      DynForm := TForm.create(self);
      with DynForm do
      begin
        caption := 'Dimensionsbestimmung ' + nextp(Line, '=', 0);
        Position := poScreenCenter;
        clientwidth := 350;
        clientheight := 40;
        insertcontrol(AskLabel);
        insertcontrol(AskSelect);

        // Controlls füllen!
        DimensionValues := TStringList.create;
        DimensionValues.loadfromFile(RohdatenFName(strtointdef(nextp(Line, 'from', 1), 0)));
        DimensionValues.delete(0);
        for n := 0 to pred(DimensionValues.count) do
        begin
          if (pos('"', DimensionValues[n]) = 1) then
            DimensionValues[n] := ExtractSegmentBetween(DimensionValues[n], '"', '"');
        end;
        DimensionValues.sort;

        AskSelect.items.assign(DimensionValues);
        DimensionValues.free;

        ShowModal;
      end;

      result := AskSelect.text;
      break;
    end;

    // Paramerter muss wiederum aufgelöst werden ...
    n := pos('=select ', Line);
    if (n > 0) then
    begin
      ExecuteStatement := ResolveParameter(copy(Line, n + 1, MaxInt),nil);
      result := copy(Line, 1, n) + e_r_sqls(ExecuteStatement);
      break;
    end;

  until true;
end;

end.

