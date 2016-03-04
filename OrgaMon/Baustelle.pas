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
unit Baustelle;
{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Buttons,
  ExtCtrls, StdCtrls,
  Mask, Grids,
  ComCtrls, CheckLst,

  // ibo
  IB_UpdateBar, IB_NavigationBar, IB_SearchBar,
  IB_Components, IB_Process, IB_DataScan,
  IB_Session, IB_Export, IB_Import,
  IB_Access, IB_Grid, IB_Controls,

  //
  IdComponent,

  // anfix
  WordIndex, anfix32,
  Sperre, JvExControls, JvArrayButton, IB_EditButton;

type
  TFormBaustelle = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Query3: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label4: TLabel;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    TabSheet2: TTabSheet;
    CheckListBox1: TCheckListBox;
    Label8: TLabel;
    Label3: TLabel;
    IB_Memo1: TIB_Memo;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button3: TButton;
    IB_Query5: TIB_Query;
    TabSheet4: TTabSheet;
    Button5: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    CheckBox1: TCheckBox;
    Label13: TLabel;
    TabSheet5: TTabSheet;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    IB_Text1: TIB_Text;
    ComboBox2: TComboBox;
    Label17: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label19: TLabel;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    Label20: TLabel;
    IB_Edit5: TIB_Edit;
    Button8: TButton;
    IB_Query10: TIB_Query;
    Button9: TButton;
    Label21: TLabel;
    CheckBox12: TCheckBox;
    Label22: TLabel;
    Label23: TLabel;
    IB_Query11: TIB_Query;
    Button10: TButton;
    TabSheet6: TTabSheet;
    Button11: TButton;
    IB_Query12: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    TabSheet7: TTabSheet;
    Label24: TLabel;
    IB_Edit6: TIB_Edit;
    CheckBox15: TCheckBox;
    IB_QueryOrte: TIB_Query;
    TabSheet8: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    IB_CheckBox1: TIB_CheckBox;
    IB_Memo2: TIB_Memo;
    Button4: TButton;
    Button6: TButton;
    Label25: TLabel;
    Label26: TLabel;
    Button12: TButton;
    ComboBox3: TComboBox;
    IB_DSQL4: TIB_DSQL;
    TabSheet9: TTabSheet;
    CheckBox16: TCheckBox;
    IB_Query6: TIB_Query;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label18: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    IB_Date1: TIB_Date;
    IB_Date2: TIB_Date;
    IB_Edit3: TIB_Edit;
    IB_Edit4: TIB_Edit;
    IB_Edit7: TIB_Edit;
    IB_Edit8: TIB_Edit;
    Label16: TLabel;
    IB_Memo3: TIB_Memo;
    Button16: TButton;
    IB_Memo5: TIB_Memo;
    IB_Edit9: TIB_Edit;
    Label29: TLabel;
    Label30: TLabel;
    Button18: TButton;
    CheckBox17: TCheckBox;
    IB_CheckBox6: TIB_CheckBox;
    Button20: TButton;
    IB_CheckBox5: TIB_CheckBox;
    Button21: TButton;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    Label33: TLabel;
    Edit2: TEdit;
    CheckBox22: TCheckBox;
    ComboBox4: TComboBox;
    Label34: TLabel;
    Label35: TLabel;
    IB_Memo6: TIB_Memo;
    Label36: TLabel;
    Button15: TButton;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    SpeedButton15: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Label38: TLabel;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Image2: TImage;
    IB_UpdateBar1: TIB_UpdateBar;
    ComboBox5: TComboBox;
    Label39: TLabel;
    IB_CheckBox7: TIB_CheckBox;
    IB_CheckBox8: TIB_CheckBox;
    Button26: TButton;
    Button28: TButton;
    IB_Grid3: TIB_Grid;
    IB_DataSource3: TIB_DataSource;
    IB_Query7: TIB_Query;
    Button29: TButton;
    CheckBox26: TCheckBox;
    Button30: TButton;
    TabSheet10: TTabSheet;
    Button7: TButton;
    Button14: TButton;
    ProgressBar1: TProgressBar;
    Edit5: TEdit;
    Label41: TLabel;
    Button32: TButton;
    SpeedButton1: TSpeedButton;
    Button33: TButton;
    Label45: TLabel;
    CheckBox27: TCheckBox;
    IB_CheckBox2: TIB_CheckBox;
    IB_CheckBox3: TIB_CheckBox;
    CheckBox28: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    CheckBox32: TCheckBox;
    Edit7: TEdit;
    Edit8: TEdit;
    Label47: TLabel;
    TabSheet11: TTabSheet;
    CheckBox33: TCheckBox;
    IB_Query8: TIB_Query;
    IB_DataSource4: TIB_DataSource;
    IB_Grid4: TIB_Grid;
    Button27: TButton;
    IB_Grid5: TIB_Grid;
    IB_Query13: TIB_Query;
    IB_DataSource5: TIB_DataSource;
    Button35: TButton;
    Label48: TLabel;
    Button36: TButton;
    SpeedButton20: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label49: TLabel;
    SpeedButton2: TSpeedButton;
    Label50: TLabel;
    SpeedButton8: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Button37: TButton;
    Button38: TButton;
    CheckBox35: TCheckBox;
    SpeedButton5: TSpeedButton;
    ListBox1: TListBox;
    IB_Query2: TIB_Query;
    IB_DataSource6: TIB_DataSource;
    Button39: TButton;
    IB_Grid6: TIB_Grid;
    SpeedButton6: TSpeedButton;
    Label53: TLabel;
    CheckBox36: TCheckBox;
    Label55: TLabel;
    Edit9: TEdit;
    CheckBox37: TCheckBox;
    Label46: TLabel;
    Edit6: TEdit;
    Button34: TButton;
    Label31: TLabel;
    Label37: TLabel;
    Label40: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Button17: TButton;
    Button19: TButton;
    Edit1: TEdit;
    Edit3: TEdit;
    CheckBox25: TCheckBox;
    Button22: TButton;
    Edit4: TEdit;
    CheckBox34: TCheckBox;
    Edit11: TEdit;
    Edit12: TEdit;
    CheckBox38: TCheckBox;
    CheckBox39: TCheckBox;
    TabSheet12: TTabSheet;
    Label43: TLabel;
    Label44: TLabel;
    SpeedButton7: TSpeedButton;
    SpeedButton9: TSpeedButton;
    IB_CheckBox4: TIB_CheckBox;
    IB_Memo4: TIB_Memo;
    IB_Memo7: TIB_Memo;
    Button40: TButton;
    Button13: TButton;
    Label1: TLabel;
    IB_Edit10: TIB_Edit;
    Label9: TLabel;
    Label58: TLabel;
    ComboBox1: TComboBox;
    ComboBox6: TComboBox;
    Button31: TButton;
    Button41: TButton;
    Edit10: TEdit;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    ListBox2: TListBox;
    SpeedButton12: TSpeedButton;
    Button42: TButton;
    SpeedButton13: TSpeedButton;
    Label51: TLabel;
    ComboBox7: TComboBox;
    Button43: TButton;
    IB_CheckBox9: TIB_CheckBox;
    SpeedButton21: TSpeedButton;
    SpeedButton14: TSpeedButton;
    Label52: TLabel;
    StatusBar1: TStatusBar;
    Button2: TButton;
    Memo1: TMemo;
    Edit13: TEdit;
    SpeedButton16: TSpeedButton;
    Label54: TLabel;
    Label59: TLabel;
    Edit14: TEdit;
    CheckBox40: TCheckBox;
    CheckBox41: TCheckBox;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    Label64: TLabel;
    SpeedButton19: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure IB_Query5BeforePost(IB_Dataset: TIB_Dataset);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ComboBox3DropDown(Sender: TObject);
    procedure IB_Edit7GetDisplayText(Sender: TObject; var AString: string);
    procedure IB_Edit7SetEditText(Sender: TObject; var AString: string);
    procedure IB_Edit7GetEditText(Sender: TObject; var AString: string);
    procedure IB_Edit7IsValidChar(Sender: TObject; var AChar: Char;
      var IsValid: Boolean);
    procedure Button16Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Edit3Change(Sender: TObject);
    procedure IB_Edit4Change(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox33Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure IB_Query8AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Grid4GetDisplayText(Sender: TObject; ACol, ARow: Integer;
      var AString: string);
    procedure Button35Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox6Select(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure SpeedButton13Click(Sender: TObject);
    procedure ComboBox7Select(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
  private

    { Private-Deklarationen }

    IBQ5_ReOrg: Boolean;
    BreakIt: Boolean;
    IsRunning: Boolean;

    procedure LogFoto(s: string); overload;
    procedure LogFoto(s: TStringList); overload;
    procedure WaitFor(s: string);
    function RestoreFName: string;
    procedure ClearMonteurZuordnung;
    procedure FotoZip;
    procedure FotoUp;

    // FTP-Dinger
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);

    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);

    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);

  public
    { Public-Deklarationen }
    AutoYES: Boolean;

    procedure ReflectMonteurInfo;
    procedure ReflectArbeitszeitInfo;
    procedure ReflectFotoPath;
    procedure ExecuteLoeschen(Nachfragen: Boolean);
    procedure VerwaisteHistorischeDatensaetzeLoeschen;
    procedure AblageLoeschen;
    procedure SetContext(RID: Integer);
    procedure mShow;
    procedure ReflectZustaendige;
    procedure ReadState;

  end;

var
  FormBaustelle: TFormBaustelle;

implementation

uses
  Jvgnugettext, wanfix32,
  globals, math, clipbrd,
  SimplePassword, dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Datensicherung, Einstellungen, AuftragArbeitsplatz,
  CareTakerClient, FastGEO,
  GeoLokalisierung, AuftragGeo,
  gplists, AuftragImport, AuftragBildzuordnung,
  Belege, Person, Vertrag,
  Kontext, Datenbank, AuftragSuchindex,
  BaustelleFoto, REST, CCR.Exif,
  AuftragErgebnis, mapping, InfoZIP,
  Bearbeiter, CommCtrl,
  // Indy
  IdFTP, SolidFTP,

  OrientationConvert, FotoMeldung, Feiertage;
{$R *.DFM}

procedure TFormBaustelle.FormActivate(Sender: TObject);
var
  BaustellenS: TStringList;
begin

  // verfügbare Baustellen
  BaustellenS := e_r_Baustellen;
  ComboBox5.items.assign(BaustellenS);
  ComboBox1.items.assign(FormBearbeiter.FetchKuerzel);
  ComboBox6.items.assign(FormBearbeiter.FetchKuerzel);
  BaustellenS.free;

  // Bundesland lesen
  ReadState;

  if not(IB_Query1.Active) then
  begin
    IB_Query1.Open;
    Edit2.text := copy(i_c_DataBaseFName, 1, revpos('/', i_c_DataBaseFName));
  end
  else
  begin
    if (IB_Query1.State <> dssEdit) then
      IB_Query1.refresh;
  end;
  CheckListBox1.items.clear;

  //
  ReflectMonteurInfo;
end;

procedure TFormBaustelle.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
var
  MemoField: TStringList;
  sRID: TStringList;
  sKUERZEL: TStringList;

  n: Integer;
begin
  ReflectArbeitszeitInfo;
  with IB_Dataset do
  begin
    // wegen AutoInc
    if FieldByName('RID').IsNull then
      FieldByName('RID').AsInteger := cRID_AutoInc;
    MemoField := TStringList.create;
    sRID := TStringList.create;
    sKUERZEL := TStringList.create;
    FieldByName('INFO').AssignTo(MemoField);
    for n := 0 to pred(CheckListBox1.items.count) do
      if CheckListBox1.Checked[n] then
      begin
        sKUERZEL.Add(CheckListBox1.items[n]);
        sRID.Add(inttostr(e_r_MonteurRIDFromKuerzel(CheckListBox1.items[n])));
      end;
    MemoField.values['MONTEURE'] :=
    { } HugeSingleLine(sRID, ',') +
    { } ' [' +
    { } HugeSingleLine(sKUERZEL, ',') +
    { } ']';
    FieldByName('INFO').assign(MemoField);
    MemoField.free;
    sRID.free;
    sKUERZEL.free;
  end;
  //
end;

procedure TFormBaustelle.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(_('Baustelle') + #13 + FieldByName('NUMMERN_PREFIX').AsString + #13
      + _('wirklich löschen'), true) then
    begin
      // e_w_preDeleteBaustelle(Fieldbyname('RID').AsInteger);
      Confirmed := true;
    end;

end;

procedure TFormBaustelle.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormBaustelle.FormResize(Sender: TObject);
var
  PanelRect: TRect;
begin
  // Retreive the rectancle of the statuspanel (in my case the second)
  SendMessage(StatusBar1.Handle, SB_GETRECT, 1, Integer(@PanelRect));
  // Position the progressbar over the panel on the statusbar
  with PanelRect do
    ProgressBar1.SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

procedure TFormBaustelle.FotoUp;
var
  Settings: TStringList;

var
  iFTP: TIdFTPRestart;
  n: Integer;
  NativeFileName: string;
  Local_FSize: Int64;
  FTP_FSize: Int64;
  BAUSTELLE_R: Integer;
  FTP_UploadFiles: TStringList;

  // Parameter
  FTPServer_Fotos, FTPBenutzer_Fotos, FTPPasswort_Fotos,
    FTPVerzeichnis_Fotos: string;
begin
  BeginHourGlass;
  FTP_UploadFiles := TStringList.create;
  Settings := nil;
  iFTP := nil;
  repeat
    BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
    dir(e_r_BaustelleUploadPath(BAUSTELLE_R) + '*.zip', FTP_UploadFiles, false);
    if (FTP_UploadFiles.count = 0) then
    begin
      LogFoto('Es gibt nichts zum Hochladen!');
      break;
    end;
    for n := 0 to pred(FTP_UploadFiles.count) do
      FTP_UploadFiles[n] := e_r_BaustelleUploadPath(BAUSTELLE_R) +
        FTP_UploadFiles[n];

    // Parameter laden
    Settings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID='
      + inttostr(BAUSTELLE_R));
    FTPServer_Fotos := e_r_ParameterFoto(Settings, cE_FTPHOST);
    FTPBenutzer_Fotos := e_r_ParameterFoto(Settings, cE_FTPUSER);
    FTPPasswort_Fotos := e_r_ParameterFoto(Settings, cE_FTPPASSWORD);
    FTPVerzeichnis_Fotos := e_r_ParameterFoto(Settings, cE_FTPVerzeichnis);

    for n := 0 to pred(FTP_UploadFiles.count) do
    begin

      // Init
      iFTP := TIdFTPRestart.create(self);
      SolidInit(iFTP);
      with iFTP do
      begin
        OnWork := IdFTP1Work;
        OnWorkBegin := IdFTP1WorkBegin;
        OnWorkEnd := IdFTP1WorkEnd;

        Host := FTPServer_Fotos;
        UserName := nextp(FTPBenutzer_Fotos, '\', 0);
        password := FTPPasswort_Fotos;

        // Prüfung der FTP Daten
        if (UserName = '') then
        begin
          LogFoto(cERRORText + ' Kein Eintrag in FTPBenutzer=');
          break;
        end;
        if (Host = '') then
          LogFoto(cWARNINGText + ' Kein Eintrag in FTPHost=');
        if (password = '') then
          LogFoto(cWARNINGText + ' Kein Eintrag in FTPPassword=');

      end;

      Local_FSize := FSize(FTP_UploadFiles[n]);
      NativeFileName := ExtractFileName(FTP_UploadFiles[n]);

      LogFoto('Upload "' + NativeFileName + '" ' + inttostr(Local_FSize) +
        ' Byte(s) ...');

      WaitFor('Datei Upload');
      if not(SolidStore(
        { } iFTP,
        { } FTP_UploadFiles[n],
        { } FTPVerzeichnis_Fotos,
        { } NativeFileName)) then
      begin
        // FTP - ERROR
        LogFoto(cERRORText + ' ' + SolidFTP_LastError);
        break;
      end
      else
      begin

        FTP_FSize := SolidSize(
          { } iFTP,
          { } FTPVerzeichnis_Fotos,
          { } NativeFileName);

        if (FTP_FSize = Local_FSize) then
        begin
          if FileDelete(FTP_UploadFiles[n]) then
            LogFoto('... OK!');
        end
        else
        begin
          LogFoto(cERRORText + ' Datei "' + FTP_UploadFiles[n] +
            '" belegt auf der FTP-Ablage ' + inttostr(FTP_FSize) +
            ' Byte(s) - es sollten aber ' + inttostr(Local_FSize) +
            ' Byte(s) sein');
        end;

      end;

      try
        iFTP.free;
      except
      end;

    end;

  until true;

  FTP_UploadFiles.free;
  if assigned(Settings) then
    Settings.free;
  ProgressBar1.Position := 0;
  WaitFor('-');
  EndHourGlass;

end;

procedure TFormBaustelle.FotoZip;
var
  // Parameter aus den Einstellungen
  sMaxAnzahlFotosProZip: Integer;
  FotosReduced: Boolean;

  procedure reduce(s: TStringList);
  var
    n: Integer;
  begin
    for n := pred(s.count) downto sMaxAnzahlFotosProZip do
    begin
      s.Delete(n);
      FotosReduced := true;
    end;
  end;

var
  cFotoPath: string;
  cFotoUpload: string;
  cFotoZiel: string;
  cFotoAblage: string;

  BAUSTELLE_R: Integer;
  TICKET_R: Integer;
  Settings: TStringList;
  sMonteure: TStringList;
  n, m: Integer;

  // Archiv Sachen
  ZipFName: string;
  zFiles: TStringList;
  DateiAnzahl: Integer;
  DateiAnzahlGesamt: Integer;

  // Bilder-Listen
  sFilesErfolg: TStringList;
  sFilesUnbenannt: TStringList;

  // Parameter aus den Einstellungen
  sPassword: string;

begin
  BeginHourGlass;
  FotosReduced := false;
  DateiAnzahlGesamt := 0;
  zFiles := TStringList.create;
  sMonteure := TStringList.create;
  sFilesErfolg := TStringList.create;
  sFilesUnbenannt := TStringList.create;

  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  TICKET_R := e_r_GEN('GEN_TICKET') + 1;

  Settings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' +
    inttostr(BAUSTELLE_R));
  sPassword := e_r_ParameterFoto(Settings, cE_ZIPPASSWORD);
  sMaxAnzahlFotosProZip :=
    StrToIntDef(Settings.values[cE_FotosMaxAnzahl], MaxInt);
  cFotoPath := e_r_BaustelleFotoPath(BAUSTELLE_R);
  cFotoZiel := Settings.values[cE_FotoZiel];
  if (cFotoZiel = '') then
    cFotoZiel := cFotoPath;
  cFotoUpload := e_r_BaustelleUploadPath(BAUSTELLE_R);
  CheckCreateDir(cFotoUpload);

  // Ablage der Zips (Datensicherung)
  cFotoAblage := Settings.values[cE_FotoAblage];
  if (cFotoAblage = '') then
  begin
    cFotoAblage := EigeneOrgaMonDateienPfad + 'Fotos\';
    CheckCreateDir(EigeneOrgaMonDateienPfad);
  end;
  CheckCreateDir(cFotoAblage);
  CheckCreateDir(cFotoAblage + 'Zips\');

  // Erkannte Bilddateien
  ZipFName := cFotoUpload + inttostrN(TICKET_R, cE_TANLENGTH) + '-Bilder' +
    cZIPExtension;
  if FileExists(ZipFName) then
    FileMove(ZipFName, cFotoUpload + FindANewPassword('', 4) + '-Bilder' +
      cZIPExtension);

  // Bilder auflisten
  dir(cFotoZiel + '*' + cImageExtension, sFilesErfolg, false);

  // Reduzieren
  reduce(sFilesErfolg);

  // Komplettieren
  for n := 0 to pred(sFilesErfolg.count) do
    sFilesErfolg[n] := cFotoZiel + sFilesErfolg[n];

  if (sFilesErfolg.count > 0) then
  begin

    LogFoto('Erstelle ' + ExtractFileName(ZipFName) + ' ...');
    DateiAnzahl := InfoZIP.zip(sFilesErfolg, ZipFName,
      { } infozip_Password + '=' + sPassword + ';' +
      { } infozip_Level + '=' + '0' + ';' +
      { } infozip_RootPath + '=' + cFotoZiel);

    FileCopy(ZipFName, cFotoAblage + 'Zips\' + e_w_Medium + '-Bilder' +
      cZIPExtension);
    inc(DateiAnzahlGesamt, DateiAnzahl);
  end;

  // Unbenannte Bilddateien
  ZipFName := cFotoUpload + inttostrN(TICKET_R, cE_TANLENGTH) +
    '-Bilder_Unbenannt' + cZIPExtension;
  if FileExists(ZipFName) then
    FileMove(ZipFName, cFotoUpload + FindANewPassword('', 4) +
      '-Bilder_Unbenannt' + cZIPExtension);

  // Monteure ermitteln
  dir(cFotoPath + '*.', sMonteure);
  for n := pred(sMonteure.count) downto 0 do
    if not((length(sMonteure[n]) = 3) and (StrToIntDef(sMonteure[n], 0) > 0))
    then
      sMonteure.Delete(n);

  // Verzeichnisse durchsuchen
  for n := 0 to pred(sMonteure.count) do
  begin
    dir(cFotoPath + sMonteure[n] + '\' + '*' + cImageExtension, sFilesUnbenannt,
      false, true);
    for m := 0 to pred(sFilesUnbenannt.count) do
      zFiles.Add(sMonteure[n] + '\' + sFilesUnbenannt[m]);
  end;

  // Reduzieren!
  reduce(zFiles);

  // Komplettieren
  for n := 0 to pred(zFiles.count) do
    zFiles[n] := cFotoPath + zFiles[n];

  if (zFiles.count > 0) then
  begin

    LogFoto('Erstelle ' + ExtractFileName(ZipFName) + ' ...');
    DateiAnzahl := InfoZIP.zip(zFiles, ZipFName,
      { } infozip_Password + '=' + sPassword + ';' +
      { } infozip_Level + '=' + '0' + ';' +
      { } infozip_RootPath + '=' + cFotoPath);

    FileCopy(ZipFName, cFotoAblage + 'Zips\' + e_w_Medium + '-Bilder_Unbenannt'
      + cZIPExtension);
    inc(DateiAnzahlGesamt, DateiAnzahl);
  end;

  if (DateiAnzahlGesamt > 0) then
  begin
    e_w_GEN('GEN_TICKET');
    // Bilder auch löschen?
    if CheckBox36.Checked then
    begin
      // Erkannte Bilder
      for n := 0 to pred(sFilesErfolg.count) do
        FileDelete(sFilesErfolg[n]);

      // Unbenannte Bilder
      for n := 0 to pred(zFiles.count) do
        FileDelete(zFiles[n]);
    end;
  end;

  Settings.free;
  sMonteure.free;
  zFiles.free;
  sFilesErfolg.free;
  sFilesUnbenannt.free;
  EndHourGlass;

  // Weitere Zips erstellen?!
  if FotosReduced then
    FotoZip;

end;

procedure TFormBaustelle.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  ReflectMonteurInfo;
  Label19.caption := 'Anzahl der Änderungen';
  IB_Query12.close;
  IB_Query7.close;

  // Anzeige der verbundenen Verträge
  if CheckBox33.Checked then
  begin
    IB_Query8.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID')
      .AsInteger;
    if not(IB_Query8.Active) then
      IB_Query8.Open;
    IB_Query8.AfterScroll(IB_Query8);
  end
  else
  begin
    IB_Query8.close;
    IB_Query13.close;
  end;

  // Anzeige der eingetragenen Bearbeiter
  ReflectZustaendige;

  // Bundesland auslesen
  ReadState;
  ReflectFotoPath;
end;

procedure TFormBaustelle.Button1Click(Sender: TObject);
var
  _FirstNumber: Integer;
  _FirstNumberOrg: Integer;
  Starttime: dword;
  RecN: Integer;
  BAUSTELLE_R: Integer;
begin
  // Letzte vergebene Nummer ermitteln
  BeginHourGlass;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  _FirstNumber := e_r_AuftragNummer(BAUSTELLE_R) + 1;
  EndHourGlass;

  if doit('Als erste Nummer wird ' + inttostr(_FirstNumber) + ' vergeben!' + #13
    + 'Jetzt durchnummerieren') then
  begin

    BeginHourGlass;
    WaitFor('Nummer setzen');

    // Nummern vergeben
    _FirstNumberOrg := _FirstNumber;
    Starttime := 0;
    RecN := 0;
    with IB_Query3 do
    begin
      ParamByName('CROSSREF').AsInteger := BAUSTELLE_R;
      Open;
      EnsureHourGlass;
      ProgressBar1.max := RecordCount;
      first;
      while not(eof) do
      begin
        if (FieldByName('NUMMER').AsInteger = 0) then
        begin
          edit;
          FieldByName('NUMMER').AsInteger := _FirstNumber;
          inc(_FirstNumber);
          post;
        end;
        next;
        inc(RecN);
        if frequently(Starttime, 400) or eof then
        begin
          application.processmessages;
          ProgressBar1.Position := RecN;
        end;
      end;
      WaitFor('-');
      ProgressBar1.Position := 0;
    end;
    EndHourGlass;
    if (_FirstNumberOrg <> _FirstNumber) then
      ShowMessage('Es wurde bis Nummer ' + inttostr(pred(_FirstNumber)) +
        ' durchnummeriert!')
    else
      ShowMessage('Es wurde nichts gefunden, was einer neuen Nummer bedarf!');
  end;
end;

procedure TFormBaustelle.FormDeactivate(Sender: TObject);
begin
  InvalidateCache_Baustelle;
  FormAuftragArbeitsplatz.NotifyBaustelleChanged(Sender);
end;

procedure TFormBaustelle.ReflectMonteurInfo;
var
  MemoField: TStringList;
  MonteurSubs: string;
  n: Integer;
  RID: Integer;
  MonteurKuerzel: string;
begin
  //
  if (CheckListBox1.items.count = 0) then
    CheckListBox1.items.assign(e_r_MonteureCache);

  //
  MemoField := TStringList.create;
  IB_Query1.FieldByName('INFO').AssignTo(MemoField);
  MonteurSubs := MemoField.values['MONTEURE'];

  // Text hinter den Zahlen wegschneiden
  n := pos('[', MonteurSubs);
  if n > 0 then
    MonteurSubs := cutblank(copy(MonteurSubs, 1, pred(n)));

  MemoField.free;

  //
  for n := 0 to pred(CheckListBox1.items.count) do
    CheckListBox1.Checked[n] := false;
  while (MonteurSubs <> '') do
  begin
    RID := StrToIntDef(nextp(MonteurSubs, ','), cRID_Null);
    if RID >= cRID_FirstValid then
    begin
      MonteurKuerzel := e_r_MonteurKuerzel(RID);
      n := CheckListBox1.items.indexof(MonteurKuerzel);
      if (n <> -1) then
        CheckListBox1.Checked[n] := true
      else
        ShowMessage('ACHTUNG: Die Monteur-Zuordnung zu' + #13 +
          'Baustellen schlägt fehl! Geben Sie allen' + #13 +
          'Monteuren eindeutige Kürzel!');
    end;
  end;
end;

function TFormBaustelle.RestoreFName: string;
var
  BackupGID: Integer;
begin
  repeat

    // über ein Spare oder was auch immer
    if (Edit12.text <> '') then
    begin
      result := Edit12.text;
      break;
    end;

    // über ein Backup
    if (Edit1.text <> '') then
    begin
      BackupGID := strtol(Edit1.text);
      if (iDataBaseBackUpDir = '') then
        result := iDataBaseHost + ':' + i_c_DataBasePath + 'sicherung_' +
          inttostrN(BackupGID, 8) + '.fdb'
      else
        result := iDataBaseHost + ':' + iDataBaseBackUpDir + 'sicherung_' +
          inttostrN(BackupGID, 8) + '.fdb';
      break;
    end;

  until true;
end;

procedure TFormBaustelle.CheckBox33Click(Sender: TObject);
begin
  IB_Query1.AfterScroll(IB_Query1);
end;

procedure TFormBaustelle.CheckListBox1ClickCheck(Sender: TObject);
begin
  if (IB_Query1.State <> dssEdit) and (IB_Query1.State <> dssinsert) then
    IB_Query1.edit;
end;

procedure TFormBaustelle.ClearMonteurZuordnung;
var
  n: Integer;
begin
  with CheckListBox1 do
  begin
    items.assign(e_r_MonteureCache);
    for n := 0 to pred(items.count) do
      Checked[n] := false;
  end;
end;

procedure TFormBaustelle.FormCreate(Sender: TObject);
var
  PanelRect: TRect;
begin
  PageControl1.ActivePage := TabSheet1;
  // Place progressbar on the statusbar
  ProgressBar1.Parent := StatusBar1;
  // TControl().SetParent(StatusBar1);
  // Retreive the rectancle of the statuspanel (in my case the second)
  SendMessage(StatusBar1.Handle, SB_GETRECT, 1, Integer(@PanelRect));
  // Position the progressbar over the panel on the statusbar
  with PanelRect do
    ProgressBar1.SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

procedure TFormBaustelle.Button30Click(Sender: TObject);
var
  lPOSTLEITZAHL_R: TgpIntegerList;
  POSTLEITZAHL_R: Integer;
  n: Integer;
  BAUSTELLE_R: Integer;
  cAUFTRAG: TIB_Cursor;
  p: Tpoint2D;
begin
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  if (BAUSTELLE_R > 0) then
  begin
    BeginHourGlass;
    WaitFor('unlocate');

    // Prepare Phase 1
    lPOSTLEITZAHL_R :=
      e_r_sqlm('select distinct POSTLEITZAHL_R from AUFTRAG where ' +
      'BAUSTELLE_R=' + inttostr(BAUSTELLE_R));

    // Prepare Phase 2
    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      sql.Add('select distinct ' +
        { } 'KUNDE_STRASSE, ' +
        { } 'KUNDE_ORT, ' +
        { } 'KUNDE_ORTSTEIL ' +
        { } 'from AUFTRAG where ' +
        { } 'BAUSTELLE_R=' + inttostr(BAUSTELLE_R));
      Open;
      APiFirst;

    end;

    ProgressBar1.max := lPOSTLEITZAHL_R.count + cAUFTRAG.RecordCount;
    ProgressBar1.Position := 0;

    // Phase 1 : die direkten Einträge löschen
    for n := 0 to pred(lPOSTLEITZAHL_R.count) do
    begin
      e_w_unlocate(lPOSTLEITZAHL_R[n]);
      ProgressBar1.StepIt;
    end;

    // Phase 2 : alle passenden Caching Elemente löschen
    with cAUFTRAG do
    begin
      while not(eof) do
      begin
        repeat
          FormGeoLokalisierung.p_OffLineMode := true;
          POSTLEITZAHL_R := FormGeoLokalisierung.locate
            (FieldByName('KUNDE_STRASSE').AsString, FieldByName('KUNDE_ORT')
            .AsString, FieldByName('KUNDE_ORTSTEIL').AsString, p);
          if POSTLEITZAHL_R >= cRID_FirstValid then
            e_w_unlocate(POSTLEITZAHL_R)
          else
            break;
        until false;
        ApiNext;
        ProgressBar1.StepIt;
      end;
    end;

    lPOSTLEITZAHL_R.free;
    WaitFor('-');
    ProgressBar1.Position := 0;
    EndHourGlass;
  end;

end;

procedure TFormBaustelle.Button31Click(Sender: TObject);
begin
  IB_Query1.FieldByName('BEARBEITUNG_R').AsInteger := sBearbeiter;
  ReflectZustaendige;
end;

procedure TFormBaustelle.Button32Click(Sender: TObject);
var
  qAUFTRAG: TIB_Query;
  BAUSTELLE_R: Integer;
  Starttime: dword;
  RecN: Integer;
  TANLog: TSearchStringList;
  txtINTERN: TStringList;
  n, k: Integer;
  IstDatum, SollDatum: TANFIXDAte;
  IstUhr, SollUhr: TAnfixTime;
  sZeitStempel: string;
  TAN: string;
begin
  BeginHourGlass;
  WaitFor('TAN-Korrektur');
  txtINTERN := TStringList.create;
  TANLog := TSearchStringList.create;
  TANLog.LoadFromFile(SearchDir + 'TAN.Log.txt');
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  qAUFTRAG := DataModuleDatenbank.nQuery;
  Starttime := 0;
  RecN := 0;
  with qAUFTRAG do
  begin
    sql.Add('select * from AUFTRAG');
    sql.Add('where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.Add(' (ZAEHLER_WECHSEL is not null) and');
    sql.Add(' (STATUS<>6)');
    sql.Add('for update');
    Open;
    ProgressBar1.max := RecordCount;
    first;
    while not(eof) do
    begin

      repeat

        // Datum bestimmen
        IstDatum := DateTime2long(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
        IstUhr := DateTime2seconds(FieldByName('ZAEHLER_WECHSEL').AsDateTime);

        // Ist schon ein exakter Wert
        if (IstUhr <> 0) then
          break;

        // überhaupt Interne Infos vorhanden?
        if FieldByName('INTERN_INFO').IsNull then
          break;

        // lese die TAN aus!
        TAN := '';
        FieldByName('INTERN_INFO').AssignTo(txtINTERN);
        for n := 0 to pred(txtINTERN.count) do
        begin
          if (pos('ERGEBNIS=', txtINTERN[n]) = 1) then
          begin
            TAN := nextp(txtINTERN[n], ';', 1);
            break;

          end;
        end;
        if (TAN = '') then
          break;

        // suche die TAN in der Gesamtdatei
        k := TANLog.FindInc(TAN + ';');
        if (k = -1) then
          break;

        // Solldatum auslesen
        sZeitStempel := nextp(TANLog[k], ';', 1);
        SollDatum := date2long(nextp(sZeitStempel, ' ', 0));
        SollUhr := StrToSeconds(nextp(sZeitStempel, ' ', 1));

        if (IstDatum >= SollDatum) then
        begin
          edit;
          FieldByName('ZAEHLER_WECHSEL').AsDateTime :=
            mkDateTime(SollDatum, SollUhr);
          post;
        end;
      until true;

      inc(RecN);
      next;
      if frequently(Starttime, 444) or eof then
      begin
        ProgressBar1.Position := RecN;
        application.processmessages;
      end;

    end;
  end;
  qAUFTRAG.free;
  TANLog.free;
  txtINTERN.free;
  WaitFor('-');
  ProgressBar1.Position := 0;
  EndHourGlass;

end;

procedure TFormBaustelle.Button33Click(Sender: TObject);
// Jahr - Anteil eines Datums ändern!
var
  qAUFTRAG: TIB_Query;
  BAUSTELLE_R: Integer;
  Starttime: dword;
  RecN: Integer;
  IstDatum, SollDatum: TANFIXDAte;
  IstUhr, SollUhr: TAnfixTime;
  ActYear: string;
begin
  BeginHourGlass;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  qAUFTRAG := DataModuleDatenbank.nQuery;
  Starttime := 0;
  RecN := 0;
  ActYear := JahresZahl;
  with qAUFTRAG do
  begin
    sql.Add('select * from AUFTRAG');
    sql.Add('where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.Add(' (ZAEHLER_WECHSEL is not null) and');
    sql.Add(' (STATUS<>6)');
    sql.Add('for update');
    Open;
    ProgressBar1.max := RecordCount;
    first;
    while not(eof) do
    begin

      // Datum bestimmen
      IstDatum := DateTime2long(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
      IstUhr := DateTime2seconds(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
      SollUhr := IstUhr;
      SollDatum := date2long(copy(long2date(IstDatum), 1, 6) + ActYear);

      if (IstDatum <> SollDatum) then
      begin
        edit;
        FieldByName('ZAEHLER_WECHSEL').AsDateTime :=
          mkDateTime(SollDatum, SollUhr);
        post;
      end;

      inc(RecN);
      next;
      if frequently(Starttime, 444) or eof then
      begin
        ProgressBar1.Position := RecN;
        application.processmessages;
      end;

    end;
  end;
  qAUFTRAG.free;
  ProgressBar1.Position := 0;
  EndHourGlass;
end;

procedure TFormBaustelle.Button34Click(Sender: TObject);
begin
  if (Edit6.text = datum) then
  begin
    if doit('Wurde zuvor eine Datensicherung gemacht') then
    begin
      BeginHourGlass;
      e_x_sql('delete from ABLAGE');
      EndHourGlass;
    end;
  end
  else
  begin
    ShowMessage('Falscher Sicherungscode!');
  end;
end;

procedure TFormBaustelle.Button35Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query13.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.Button36Click(Sender: TObject);
begin
  FormVertrag.SetContext(IB_Query13.FieldByName('VERTRAG_R').AsInteger);
end;

procedure TFormBaustelle.Button37Click(Sender: TObject);
begin
  FormAuftragSuchIndex.ReCreateTheIndex(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.Button39Click(Sender: TObject);
var
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
begin

  BeginHourGlass;
  IB_Query2.close;

  //
  if CheckBox40.Checked then
  begin
    //
    rTRANSACTION := TIB_Transaction.create(self);
    with rTRANSACTION do
    begin
      Isolation := tiCommitted;
      AutoCommit := true;
      ReadOnly := true;
    end;

    //
    rCONNECTION := TIB_Connection.create(self);
    with rCONNECTION do
    begin
      DefaultTransaction := rTRANSACTION;
      LoginDBReadOnly := true;
      Protocol := cpTCP_IP;
      DataBaseName := RestoreFName;
      UserName := 'SYSDBA';
      password := deCrypt_Hex(iDataBase_SYSDBA_pwd);
    end;

    with rTRANSACTION do
    begin
      IB_connection := rCONNECTION;
    end;

    rCONNECTION.connect;

    IB_Query2.IB_connection := rCONNECTION;

  end
  else
  begin
    IB_Query2.IB_connection := DataModuleDatenbank.IB_Connection1;
  end;

  IB_Query2.ParamByName('CROSSREF').assign(IB_Query1.FieldByName('RID'));
  IB_Query2.Open;
  EndHourGlass;
end;

procedure TFormBaustelle.Button3Click(Sender: TObject);
begin
  ExecuteLoeschen(true);
end;

procedure TFormBaustelle.Button5Click(Sender: TObject);

  function suchStr(Q: TIB_Dataset): string;
  var
    sIntern: TStringList;
  begin
    with Q do
    begin
      repeat
        if CheckBox32.Checked then
        begin
          sIntern := TStringList.create;
          FieldByName('INTERN_INFO').AssignTo(sIntern);
          result := sIntern.values[Edit7.text];
          sIntern.free;
          break;
        end;
        result := FieldByName('ZAEHLER_NUMMER').AsString;
      until true;

      if CheckBox12.Checked then
        result := result + FieldByName('ART').AsString;
      if CheckBox28.Checked then
        result := result + FieldByName('KUNDE_ORT').AsString;
    end;
  end;

var
  TargetRID: Integer;
  SourceRID: Integer;
  FehlerStrings: TStringList;
  Anz_Aenderungen: Integer;
  Starttime: dword;
  RecN: Integer;
  ZaehlerInfosBisher: TStringList;
  ZaehlerInfosNeu: TStringList;
  ZielZaehlerNummern: TStringList;
  IB_CursorZAEHLERNUMMERN: TIB_Cursor;
  SuchBezeichnung: string;
  k, l: Integer;
  CountDoppelte: Integer;
  //
  cQUELLE: TIB_Cursor;
  qAUFTRAG: TIB_Query;
  qZIEL: TIB_Query;
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;

begin
  //
  rCONNECTION := nil;
  rTRANSACTION := nil;

  //
  TargetRID := IB_Query1.FieldByName('RID').AsInteger;
  SourceRID := e_r_BaustelleRIDFromKuerzel(ComboBox2.text);
  //
  cQUELLE := DataModuleDatenbank.nCursor;

  // ev. aus einer anderen Datenbank?
  if (length(Edit2.text) > 0) then
  begin
    if not((copy(Edit2.text, length(Edit2.text), 1) = '/') or
      (copy(Edit2.text, length(Edit2.text), 1) = '/')) then
    begin

      rTRANSACTION := TIB_Transaction.create(self);
      with rTRANSACTION do
      begin
        Isolation := tiCommitted;
        AutoCommit := true;
        ReadOnly := true;
      end;

      rCONNECTION := TIB_Connection.create(self);
      with rCONNECTION do
      begin
        DefaultTransaction := rTRANSACTION;
        LoginDBReadOnly := true;
        Protocol := cpTCP_IP;
        DataBaseName := iDataBaseHost + ':' + Edit2.text;
        UserName := 'SYSDBA';
        password := SysDBAPassword;
      end;

      with rTRANSACTION do
      begin
        IB_connection := rCONNECTION;
      end;

      rCONNECTION.connect;
      cQUELLE.IB_connection := rCONNECTION;

      SourceRID := TargetRID;

    end
    else
    begin
      if (SourceRID = TargetRID) then
        exit;
    end;
  end;

  if (SourceRID <> -1) then
  begin
    cQUELLE.sql.Add('select * from AUFTRAG where');
    cQUELLE.sql.Add(' (BAUSTELLE_R=:CROSSREF) AND');
    cQUELLE.sql.Add(' (RID=MASTER_R)');

    //
    qZIEL := DataModuleDatenbank.nQuery;
    qZIEL.sql.Add('select * from AUFTRAG where RID=:CROSSREF for update');

    FehlerStrings := TStringList.create;
    ZaehlerInfosBisher := TStringList.create;
    ZaehlerInfosNeu := TStringList.create;
    ZielZaehlerNummern := TStringList.create;

    if not(CheckBox17.Checked) then
    begin
      BeginHourGlass;
      WaitFor('Korrektur');
      IB_CursorZAEHLERNUMMERN := DataModuleDatenbank.nCursor;
      with IB_CursorZAEHLERNUMMERN do
      begin
        sql.Add('SELECT');
        sql.Add(' RID,ART,ZAEHLER_NUMMER,KUNDE_ORT,INTERN_INFO');
        sql.Add('FROM');
        sql.Add(' AUFTRAG');
        sql.Add('WHERE (BAUSTELLE_R=' + inttostr(TargetRID) + ') AND');
        sql.Add('      (MASTER_R=RID)');
        Open;
        APiFirst;
        while not(eof) do
        begin
          SuchBezeichnung := suchStr(IB_CursorZAEHLERNUMMERN);
          if (SuchBezeichnung <> '') then
            ZielZaehlerNummern.addObject(SuchBezeichnung,
              TObject(FieldByName('RID').AsInteger));
          ApiNext;
        end;
        close;
      end;
      IB_CursorZAEHLERNUMMERN.free;
      ZielZaehlerNummern.sort;
      RemoveDuplicates(ZielZaehlerNummern, CountDoppelte);
      if (CountDoppelte > 0) then
        ShowMessage('Ihre Zielbaustelle hat doppelte Zählernummern!' + #13 +
          'Dies kann zu unvollständigen Korrekturen führen!' + #13 +
          'Es wurden ' + inttostr(CountDoppelte) + ' gefunden!');
      ZielZaehlerNummern.sorted := true;

      qZIEL.Open;
      cQUELLE.ParamByName('CROSSREF').AsInteger := SourceRID;
      cQUELLE.Open;
      ProgressBar1.max := cQUELLE.RecordCount;
      ProgressBar1.Position := 0;
      cQUELLE.first;
      Anz_Aenderungen := 0;
      Starttime := 0;
      RecN := 0;
      cQUELLE.first;
      FormAuftragArbeitsplatz.ItemsMARKED.clear;
      while not(cQUELLE.eof) do
      begin

        // Identifikation
        SuchBezeichnung := suchStr(cQUELLE);
        if (SuchBezeichnung <> '') then
        begin

          k := ZielZaehlerNummern.indexof(SuchBezeichnung);
          if (k <> -1) then
          begin

            qZIEL.ParamByName('CROSSREF').AsInteger :=
              Integer(ZielZaehlerNummern.objects[k]);
            if qZIEL.IsEmpty then
            begin
              FehlerStrings.Add('Merkmal "' + SuchBezeichnung +
                '" nicht wiedergefunden!');
            end
            else
            begin

              repeat

                // ev. gar keine Berechtigung?!
                if CheckBox27.Checked then
                  if (qZIEL.FieldByName('STATUS').AsInteger <> cs_DatenFehlen)
                  then
                    break;

                FormAuftragArbeitsplatz.ItemsMARKED.Add
                  (TObject(qZIEL.FieldByName('RID').AsInteger));
                qZIEL.edit;

                if CheckBox1.Checked then
                  qZIEL.FieldByName('ZAEHLER_INFO')
                    .assign(cQUELLE.FieldByName('ZAEHLER_INFO'));

                if CheckBox7.Checked then
                begin
                  ZaehlerInfosBisher.clear;
                  ZaehlerInfosNeu.clear;
                  qZIEL.FieldByName('ZAEHLER_INFO')
                    .AssignTo(ZaehlerInfosBisher);
                  cQUELLE.FieldByName('ZAEHLER_INFO').AssignTo(ZaehlerInfosNeu);
                  ZaehlerInfosBisher.AddStrings(ZaehlerInfosNeu);
                  qZIEL.FieldByName('ZAEHLER_INFO').assign(ZaehlerInfosBisher);
                end;

                if CheckBox20.Checked then
                  qZIEL.FieldByName('MONTEUR_INFO')
                    .assign(cQUELLE.FieldByName('MONTEUR_INFO'));

                if CheckBox21.Checked then
                begin
                  ZaehlerInfosBisher.clear;
                  ZaehlerInfosNeu.clear;
                  qZIEL.FieldByName('MONTEUR_INFO')
                    .AssignTo(ZaehlerInfosBisher);
                  cQUELLE.FieldByName('MONTEUR_INFO').AssignTo(ZaehlerInfosNeu);
                  ZaehlerInfosBisher.AddStrings(ZaehlerInfosNeu);
                  qZIEL.FieldByName('MONTEUR_INFO').assign(ZaehlerInfosBisher);
                end;

                if CheckBox23.Checked then
                  qZIEL.FieldByName('INTERN_INFO')
                    .assign(cQUELLE.FieldByName('INTERN_INFO'));

                if CheckBox31.Checked then
                  qZIEL.FieldByName('ZAEHLER_NUMMER')
                    .assign(cQUELLE.FieldByName('ZAEHLER_NUMMER'));

                if CheckBox24.Checked then
                begin
                  ZaehlerInfosBisher.clear;
                  ZaehlerInfosNeu.clear;
                  qZIEL.FieldByName('INTERN_INFO').AssignTo(ZaehlerInfosBisher);
                  cQUELLE.FieldByName('INTERN_INFO').AssignTo(ZaehlerInfosNeu);
                  ZaehlerInfosBisher.AddStrings(ZaehlerInfosNeu);
                  qZIEL.FieldByName('INTERN_INFO').assign(ZaehlerInfosBisher);
                end;

                if CheckBox30.Checked then
                begin
                  ZaehlerInfosBisher.clear;
                  ZaehlerInfosNeu.clear;
                  qZIEL.FieldByName('INTERN_INFO').AssignTo(ZaehlerInfosBisher);
                  cQUELLE.FieldByName('INTERN_INFO').AssignTo(ZaehlerInfosNeu);

                  // Nun die Werte entsprechend ändern!
                  for l := 0 to pred(ZaehlerInfosNeu.count) do
                    if (pos('=', ZaehlerInfosNeu[l]) > 1) then
                      ZaehlerInfosBisher.values
                        [nextp(ZaehlerInfosNeu[l], '=', 0)] :=
                        nextp(ZaehlerInfosNeu[l], '=', 1);

                  qZIEL.FieldByName('INTERN_INFO').assign(ZaehlerInfosBisher);
                end;

                if CheckBox2.Checked then
                begin
                  if CheckBox16.Checked then
                    qZIEL.FieldByName('PLANQUADRAT').clear
                  else
                    qZIEL.FieldByName('PLANQUADRAT')
                      .assign(cQUELLE.FieldByName('PLANQUADRAT'));
                end;

                if CheckBox3.Checked then
                begin
                  qZIEL.FieldByName('SPERRE_VON')
                    .assign(cQUELLE.FieldByName('SPERRE_VON'));
                  qZIEL.FieldByName('SPERRE_BIS')
                    .assign(cQUELLE.FieldByName('SPERRE_BIS'));
                end;

                if CheckBox4.Checked then
                  qZIEL.FieldByName('KUNDE_NUMMER')
                    .assign(cQUELLE.FieldByName('KUNDE_NUMMER'));

                if CheckBox5.Checked then
                begin
                  qZIEL.FieldByName('KUNDE_NAME1')
                    .assign(cQUELLE.FieldByName('KUNDE_NAME1'));
                  qZIEL.FieldByName('KUNDE_NAME2')
                    .assign(cQUELLE.FieldByName('KUNDE_NAME2'));
                  qZIEL.FieldByName('KUNDE_STRASSE')
                    .assign(cQUELLE.FieldByName('KUNDE_STRASSE'));
                  qZIEL.FieldByName('KUNDE_ORT')
                    .assign(cQUELLE.FieldByName('KUNDE_ORT'));
                end;

                if CheckBox6.Checked then
                begin
                  qZIEL.FieldByName('BRIEF_NAME1')
                    .assign(cQUELLE.FieldByName('BRIEF_NAME1'));
                  qZIEL.FieldByName('BRIEF_NAME2')
                    .assign(cQUELLE.FieldByName('BRIEF_NAME2'));
                  qZIEL.FieldByName('BRIEF_STRASSE')
                    .assign(cQUELLE.FieldByName('BRIEF_STRASSE'));
                  qZIEL.FieldByName('BRIEF_ORT')
                    .assign(cQUELLE.FieldByName('BRIEF_ORT'));
                end;

                if CheckBox8.Checked then
                  qZIEL.FieldByName('ART').assign(cQUELLE.FieldByName('ART'));

                if CheckBox9.Checked then
                  qZIEL.FieldByName('KUNDE_NAME1')
                    .assign(cQUELLE.FieldByName('KUNDE_NAME1'));

                if CheckBox10.Checked then
                  qZIEL.FieldByName('KUNDE_NAME2')
                    .assign(cQUELLE.FieldByName('KUNDE_NAME2'));

                if CheckBox11.Checked then
                  qZIEL.FieldByName('KUNDE_ORTSTEIL')
                    .assign(cQUELLE.FieldByName('KUNDE_ORTSTEIL'));

                if CheckBox13.Checked then
                begin
                  qZIEL.FieldByName('VERBRAUCH_DATUM')
                    .assign(cQUELLE.FieldByName('VERBRAUCH_DATUM'));
                  qZIEL.FieldByName('VERBRAUCH_ZAEHLER_STAND')
                    .assign(cQUELLE.FieldByName('VERBRAUCH_ZAEHLER_STAND'));
                  qZIEL.FieldByName('VERBRAUCH_PRO_JAHR')
                    .assign(cQUELLE.FieldByName('VERBRAUCH_PRO_JAHR'));
                end;

                if CheckBox14.Checked then
                  qZIEL.FieldByName('REGLER_NR')
                    .assign(cQUELLE.FieldByName('REGLER_NR'));

                if CheckBox15.Checked then
                  qZIEL.FieldByName('WORDEMPFAENGER')
                    .assign(cQUELLE.FieldByName('WORDEMPFAENGER'));

                if CheckBox18.Checked then
                  qZIEL.FieldByName('MONTEUR1_R')
                    .assign(cQUELLE.FieldByName('MONTEUR1_R'));

                if CheckBox19.Checked then
                  qZIEL.FieldByName('MONTEUR2_R')
                    .assign(cQUELLE.FieldByName('MONTEUR2_R'));

                if CheckBox22.Checked then
                  qZIEL.FieldByName(ComboBox4.text)
                    .assign(cQUELLE.FieldByName(ComboBox4.text));

                if CheckBox29.Checked then
                begin
                  ForceHistorischer := true;
                  AuftragBeforePost(qZIEL);
                end
                else
                begin
                  AuftragBeforePost(qZIEL, true);
                end;

                qZIEL.post;
                inc(Anz_Aenderungen);

              until true;
            end;

          end
          else
          begin
            FehlerStrings.Add('Merkmal "' + SuchBezeichnung +
              '" nicht gefunden!');
          end;
        end;
        cQUELLE.next;
        inc(RecN);
        if frequently(Starttime, 333) or cQUELLE.eof then
        begin
          ProgressBar1.Position := RecN;
          application.processmessages;
          Label19.caption := inttostr(Anz_Aenderungen) + ' Änderung(en)';
        end;
      end;
      cQUELLE.close;
      qZIEL.close;
      WaitFor('-');
      ProgressBar1.Position := 0;
      EndHourGlass;
      if (FehlerStrings.count > 0) then
      begin
        FehlerStrings.SaveToFile(DiagnosePath + 'Baustelle-Korrektur.txt');
        openShell(DiagnosePath + 'Baustelle-Korrektur.txt');
      end
      else
      begin
        ShowMessage('Es gab keine Fehler');
      end;
    end
    else
    begin
      BeginHourGlass;
      WaitFor('Korrektur');
      // Sondermodus "Zählernummer" Korrektur
      FormAuftragArbeitsplatz.ItemsMARKED.clear;
      qAUFTRAG := DataModuleDatenbank.nQuery;
      with qAUFTRAG do
      begin
        sql.Add('select * from AUFTRAG where');
        sql.Add(' (BAUSTELLE_R=' + inttostr(TargetRID) + ') AND');
        sql.Add(' (STATUS<>6) AND');
        if not(CheckBox37.Checked) then
        begin
          sql.Add(' ( (KUNDE_NAME1=:N1) OR (KUNDE_NAME1 IS NULL) ) AND');
          sql.Add(' ( (KUNDE_NAME2=:N2) OR (KUNDE_NAME2 IS NULL) ) AND');
        end;
        sql.Add(' ( (KUNDE_STRASSE=:N3) OR (KUNDE_STRASSE IS NULL) ) AND');
        sql.Add(' ( (KUNDE_ORT=:N4) OR (KUNDE_ORT IS NULL) )');
        sql.Add(' for update');
        Open;
      end;

      cQUELLE.ParamByName('CROSSREF').AsInteger := SourceRID;
      cQUELLE.Open;
      ProgressBar1.max := cQUELLE.RecordCount;
      ProgressBar1.Position := 0;
      Anz_Aenderungen := 0;
      Starttime := 0;
      RecN := 0;
      cQUELLE.first;
      while not(cQUELLE.eof) do
      begin

        qAUFTRAG.params.Beginupdate;
        if not(CheckBox37.Checked) then
        begin
          qAUFTRAG.ParamByName('N1').assign(cQUELLE.FieldByName('KUNDE_NAME1'));
          qAUFTRAG.ParamByName('N2').assign(cQUELLE.FieldByName('KUNDE_NAME2'));
        end;
        qAUFTRAG.ParamByName('N3').assign(cQUELLE.FieldByName('KUNDE_STRASSE'));
        qAUFTRAG.ParamByName('N4').assign(cQUELLE.FieldByName('KUNDE_ORT'));
        qAUFTRAG.params.endupdate(true);

        qAUFTRAG.first;
        case qAUFTRAG.RecordCount of
          0:
            begin
              FehlerStrings.Add('ERROR: ' + cQUELLE.FieldByName('NUMMER')
                .AsString + ' konnte nicht gefunden werden');
            end;
          1:
            begin
              FormAuftragArbeitsplatz.ItemsMARKED.Add
                (TObject(qAUFTRAG.FieldByName('RID').AsInteger));
              inc(Anz_Aenderungen);
              if CheckBox31.Checked then
              begin
                if (qAUFTRAG.FieldByName('ZAEHLER_NUMMER').AsString <>
                  cQUELLE.FieldByName('ZAEHLER_NUMMER').AsString) then
                begin
                  qAUFTRAG.edit;
                  qAUFTRAG.FieldByName('ZAEHLER_NUMMER')
                    .assign(cQUELLE.FieldByName('ZAEHLER_NUMMER'));
                  ForceHistorischer := true;
                  AuftragBeforePost(qAUFTRAG);
                  qAUFTRAG.post;
                end
                else
                begin
                  FehlerStrings.Add('WARNUNG: ' + cQUELLE.FieldByName('NUMMER')
                    .AsString + ' ist schon identisch');
                end;
              end;
            end;
        else
          FehlerStrings.Add('ERROR: zu ' + cQUELLE.FieldByName('NUMMER')
            .AsString +
            ' gibt es folgende Alternativen (muss manuell gemacht werden!)');

          while not(qAUFTRAG.eof) do
          begin
            FehlerStrings.Add('  ' + qAUFTRAG.FieldByName('NUMMER').AsString +
              ' ' + qAUFTRAG.FieldByName('KUNDE_NAME1').AsString + ' ' +
              qAUFTRAG.FieldByName('KUNDE_NAME2').AsString);
            qAUFTRAG.next;
          end;

        end;

        cQUELLE.next;
        inc(RecN);

        if frequently(Starttime, 333) or cQUELLE.eof then
        begin
          ProgressBar1.Position := RecN;
          application.processmessages;
          Label19.caption := inttostr(Anz_Aenderungen) + ' Änderung(en)';
          if not(CheckBox17.Checked) then
            break;
        end;

      end;
      WaitFor('-');
      ProgressBar1.Position := 0;
      cQUELLE.close;
      qAUFTRAG.close;
      qAUFTRAG.free;

      FehlerStrings.Add('');
      FehlerStrings.Add(inttostr(Anz_Aenderungen) + ' Änderungen!');
      FehlerStrings.SaveToFile(DiagnosePath + 'ZNO-Korrektur.txt');
      EndHourGlass;
      openShell(DiagnosePath + 'ZNO-Korrektur.txt');

    end;
    FehlerStrings.free;
    ZaehlerInfosBisher.free;
    ZaehlerInfosNeu.free;
    ZielZaehlerNummern.free;
    qZIEL.free;
    FreeAndNil(rCONNECTION);
    FreeAndNil(rTRANSACTION);
  end;
end;

procedure TFormBaustelle.Button40Click(Sender: TObject);
var
  myMapping: TFieldMapping;
  myWiki: TStringList;
  FieldName: string;
  FileName: string;
begin
  FieldName := IB_Memo4.Lines[IB_Memo4.CaretPos.y];
  FileName := cAuftragErgebnisPath + e_r_BaustellenPfad(IB_Memo5.Lines) + '\' +
    FieldName + '.ini';
  if FileExists(FileName) then
  begin
    myMapping := TFieldMapping.create;
    myMapping.AddByIniFile(FieldName, FileName);
    myWiki := myMapping.ItemOf(FieldName).WikiTable;
    myWiki.SaveToFile(FileName + '.txt');
    myWiki.free;
    myMapping.free;
    openShell(FileName + '.txt');
  end
  else
  begin
    ShowMessage(' Datei "' + FileName + '" nicht gefunden!');
  end;
end;

procedure TFormBaustelle.Button41Click(Sender: TObject);
begin
  IB_Query1.FieldByName('VERTRETUNG_R').AsInteger := sBearbeiter;
  ReflectZustaendige;
end;

procedure TFormBaustelle.Button42Click(Sender: TObject);
var
  Settings: TStringList;
  WorkPath: string;
begin
  // im Moment nur xml2csv
  Settings := TStringList.create;

  // checks
  Settings.AddStrings(IB_Memo5.Lines);
  WorkPath := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\';
  DoConversion(Content_Mode_xml2csv, WorkPath + 'EXPORT-*.xml');
  Settings.free;
end;

procedure TFormBaustelle.Button43Click(Sender: TObject);
begin
  FormOfficialHolidays.ShowModal;
end;

procedure TFormBaustelle.Button4Click(Sender: TObject);
var
  AllOrte: TSearchStringList;
  MemoInfo: TSearchStringList;
  RecN: Integer;
  Starttime: dword;
  n: Integer;
begin
  BeginHourGlass;
  WaitFor('Ortsteile');
  with IB_QueryOrte do
  begin
    AllOrte := TSearchStringList.create;
    MemoInfo := TSearchStringList.create;
    ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    Open;
    RecN := 0;
    Starttime := 0;
    ProgressBar1.Position := 0;
    ProgressBar1.max := RecordCount;
    first;
    while not(eof) do
    begin
      if (FieldByName('KUNDE_ORTSTEIL').AsString <> '') then
        AllOrte.Add(FieldByName('KUNDE_ORTSTEIL').AsString);
      next;
      inc(RecN);
      if frequently(Starttime, 400) or (eof) then
      begin
        application.processmessages;
        ProgressBar1.Position := RecN;
      end;
      inc(RecN);
    end;
    close;
    AllOrte.sort;
    RemoveDuplicates(AllOrte);

    IB_Query1.FieldByName('ORTE').AssignTo(MemoInfo);

    // alle Orte anfügen
    for n := 0 to pred(AllOrte.count) do
      if MemoInfo.FindInc(AllOrte[n] + '=') = -1 then
        MemoInfo.Add(AllOrte[n] + '=');

    // nicht benutzte Zeilen löschen
    for n := pred(MemoInfo.count) downto 0 do
      if AllOrte.FindInc(nextp(MemoInfo[n], '=', 0)) = -1 then
        MemoInfo.Delete(n);

    // sortieren!
    MemoInfo.sort;

    if (IB_Query1.State <> dssEdit) then
      IB_Query1.edit;
    IB_Query1.FieldByName('ORTE').assign(MemoInfo);
    IB_Query1.post;

    AllOrte.free;
    MemoInfo.free;
    ProgressBar1.Position := 0;
  end;
  WaitFor('-');
  EndHourGlass;
end;

procedure TFormBaustelle.Button6Click(Sender: TObject);
var
  BAUSTELLE_R: Integer;
  MemoInfo: TSearchStringList;
  RecN: Integer;
  Starttime: dword;
  OldCode: string[2];
  NewCode: string[2];
  Changes: Integer;
begin
  BeginHourGlass;
  WaitFor('Ortsteile');
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  MemoInfo := TSearchStringList.create;
  if (IB_Query1.FieldByName('ORTE_AKTIV').AsString = 'Y') then
    IB_Query1.FieldByName('ORTE').AssignTo(MemoInfo);
  with IB_Query5 do
  begin
    ParamByName('CROSSREF').AsInteger := BAUSTELLE_R;
    Open;
    ProgressBar1.max := RecordCount;
    ProgressBar1.Position := 0;
    RecN := 0;
    Changes := 0;
    Starttime := 0;
    while not(eof) do
    begin
      OldCode := FieldByName('KUNDE_ORTSTEIL_CODE').AsString;
      edit;
      IBQ5_ReOrg := true;
      post;
      NewCode := FieldByName('KUNDE_ORTSTEIL_CODE').AsString;
      if OldCode <> NewCode then
        inc(Changes);
      inc(RecN);
      next;
      if frequently(Starttime, 400) or eof then
      begin
        ProgressBar1.Position := RecN;
        application.processmessages;
      end;
    end;
    close;
  end;
  MemoInfo.free;
  ProgressBar1.Position := 0;
  WaitFor('-');
  EndHourGlass;
  ShowMessage(inttostr(Changes) + ' Codes mussten aktualisiert werden!');
end;

procedure TFormBaustelle.IB_Query5BeforePost(IB_Dataset: TIB_Dataset);
begin
  try
    AuftragBeforePost(IB_Dataset, IBQ5_ReOrg);
  except
  end;
  IBQ5_ReOrg := false;
end;

procedure TFormBaustelle.IB_Query8AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query13.ParamByName('BELEG_R').AsInteger :=
    IB_Query8.FieldByName('BELEG_R').AsInteger;
  IB_Query13.ParamByName('BAUSTELLE_R').AsInteger :=
    IB_Query1.FieldByName('RID').AsInteger;
  if not(IB_Query13.Active) then
    IB_Query13.Open;
end;

procedure TFormBaustelle.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  ProgressBar1.Position := AWorkCount;
end;

procedure TFormBaustelle.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  ProgressBar1.max := AWorkCountMax;
end;

procedure TFormBaustelle.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.Position := 0;
end;

procedure TFormBaustelle.ComboBox1Select(Sender: TObject);
var
  BEARBEITER_R: Integer;
begin
  BEARBEITER_R := FormBearbeiter.FetchRIDFromKurz(ComboBox1.text);
  if (BEARBEITER_R >= cRID_FirstValid) then
    IB_Query1.FieldByName('BEARBEITUNG_R').AsInteger := BEARBEITER_R
  else
    IB_Query1.FieldByName('BEARBEITUNG_R').clear;
end;

procedure TFormBaustelle.ComboBox2DropDown(Sender: TObject);
var
  AllTheBaustellen: TStringList;
  k: Integer;
begin
  AllTheBaustellen := e_r_Baustellen;
  k := AllTheBaustellen.indexof
    (e_r_BaustelleKuerzel(IB_Query1.FieldByName('RID').AsInteger));
  if (k <> -1) then
    AllTheBaustellen.Delete(k);
  ComboBox2.items.assign(AllTheBaustellen);
  AllTheBaustellen.free;
end;

procedure TFormBaustelle.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Edit10.text := '';
    application.processmessages;

  end;
end;

procedure TFormBaustelle.ExecuteLoeschen(Nachfragen: Boolean);
var
  LoeschenOK: Boolean;
  AnzahlMaster: Integer;
  BAUSTELLE_R: Integer;
begin
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  LoeschenOK := not(Nachfragen);

  if not(LoeschenOK) then
  begin
    BeginHourGlass;
    AnzahlMaster := e_r_sql(
      { } 'select count(RID) from AUFTRAG ' +
      { } 'where ' +
      { } ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and' +
      { } ' (MASTER_R=RID)');

    EndHourGlass;
    LoeschenOK := doit('Sind Sie sicher, dass Sie ' + inttostr(AnzahlMaster) +
      ' Datensätze löschen wollen');
  end;

  if LoeschenOK then
  begin
    BeginHourGlass;

    // Daten löschen, die auf unsere Master-Rids referenzieren
    // VerwaisteHistorischeDatensaetzeLoeschen;

    e_w_BaustelleLoeschen(BAUSTELLE_R);
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.Button7Click(Sender: TObject);
var
  Starttime: dword;
  RecN: Integer;
  InsertN: Integer;
  DSQL_ABLAGE_Copy: TIB_DSQL;
  DSQL_ABLAGE_Del: TIB_DSQL;
  DSQL_AUFTRAG_Clear: TIB_DSQL;
  cAUFTRAG: TIB_Cursor;
  n: Integer;
  AUFTRAG_FieldNames: TStringList;
  BAUSTELLE_R: Integer;
  ABLAGE_R: Integer;

  procedure InsertCol(RID: Integer);
  begin
    with DSQL_ABLAGE_Del do
    begin
      ParamByName('CROSSREF').AsInteger := RID;
      execute;
    end;

    with DSQL_ABLAGE_Copy do
    begin
      ParamByName('CROSSREF').AsInteger := RID;
      execute;
    end;

    inc(InsertN);
  end;

begin
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;

  if AutoYES or doit('Die Baustelle wird dadurch aus' + #13 +
    'der aktuellen Bearbeitung in die' + #13 +
    'Ablage verschoben! Die Daten stehen' + #13 +
    'im Terminarbeitsplatz nicht mehr zur' + #13 +
    'Verfügung! Jetzt in die Ablage verschieben') then
  begin
    BeginHourGlass;
    WaitFor('Ablage');

    // VerwaisteHistorischeDatensaetzeLoeschen;
    ABLAGE_R := e_w_GEN('GEN_ZUSAMMENHANG');

    // Quell-Datensätze bestimmen
    cAUFTRAG := DataModuleDatenbank.nCursor;
    AUFTRAG_FieldNames := TStringList.create;
    with cAUFTRAG do
    begin
      sql.Add('select');
      sql.Add(' *');
      sql.Add('from');
      sql.Add(' AUFTRAG');
      sql.Add('where');
      sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') or ');
      sql.Add(' (MASTER_R in (select RID from AUFTRAG where (BAUSTELLE_R=' +
        inttostr(BAUSTELLE_R) + ')))');
      Open;
      // Liste der Feldnamen speichern!
      for n := 0 to pred(FieldCount) do
        AUFTRAG_FieldNames.Add(Fields[n].FieldName);
    end;

    DSQL_ABLAGE_Copy := DataModuleDatenbank.nDSQL;
    with DSQL_ABLAGE_Copy do
    begin
      sql.Add('insert into ABLAGE');
      sql.Add('(' + HugeSingleLine(AUFTRAG_FieldNames, ',') + ')');
      sql.Add('SELECT');
      sql.Add(HugeSingleLine(AUFTRAG_FieldNames, ','));
      sql.Add('FROM');
      sql.Add(' AUFTRAG');
      sql.Add('WHERE');
      sql.Add(' RID=:CROSSREF');
      prepare;
    end;

    DSQL_ABLAGE_Del := DataModuleDatenbank.nDSQL;
    with DSQL_ABLAGE_Del do
    begin
      sql.Add('DELETE FROM');
      sql.Add(' ABLAGE');
      sql.Add('WHERE');
      sql.Add(' RID=:CROSSREF');
      prepare;
    end;

    DSQL_AUFTRAG_Clear := DataModuleDatenbank.nDSQL;
    with DSQL_AUFTRAG_Clear do
    begin
      sql.Add('update');
      sql.Add(' AUFTRAG');
      sql.Add('set');
      sql.Add(' MASTER_R=RID');
      sql.Add('where');
      sql.Add(' MASTER_R is null');
      execute;
    end;

    InsertN := 0;
    ProgressBar1.Position := 0;
    Starttime := 0;
    RecN := 0;

    with cAUFTRAG do
    begin
      ProgressBar1.max := RecordCount * 2;

      // Zunächst die Masterdatensätze
      if CheckBox38.Checked then
      begin
        APiFirst;
        while not(eof) do
        begin
          if (FieldByName('RID').AsInteger = FieldByName('MASTER_R').AsInteger)
          then
            InsertCol(FieldByName('RID').AsInteger);
          ApiNext;
          if frequently(Starttime, 333) or eof then
          begin
            ProgressBar1.Position := RecN;
            application.processmessages;
          end;
          inc(RecN);
        end;
      end;

      // Nun die Historischen Datensätze
      if CheckBox39.Checked then
      begin
        APiFirst;
        while not(eof) do
        begin
          if (FieldByName('RID').AsInteger <> FieldByName('MASTER_R').AsInteger)
          then
            InsertCol(FieldByName('RID').AsInteger);
          ApiNext;
          if frequently(Starttime, 333) or eof then
          begin
            ProgressBar1.Position := RecN;
            application.processmessages;
          end;
          inc(RecN);
        end;
      end;

    end;

    // Jetzt noch den BAUSTELLE_R anpassen!
    if (Edit9.text <> '') then
    begin
      BAUSTELLE_R := StrToIntDef(Edit9.text, cRID_Null);
      if (BAUSTELLE_R > cRID_FirstValid) then
      begin
        e_x_sql(
          { } 'update ABLAGE set ' +
          { } ' BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ' ' +
          { } 'where' +
          { } ' ABLAGE_R=' + inttostr(ABLAGE_R));
      end;

    end;
    cAUFTRAG.free;
    DSQL_ABLAGE_Copy.free;
    DSQL_ABLAGE_Del.free;
    DSQL_AUFTRAG_Clear.free;
    AUFTRAG_FieldNames.free;

    Label22.caption := 'OK';
    Label23.caption := 'OK';
    ExecuteLoeschen(false);
    ProgressBar1.Position := 0;
    WaitFor('-');
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.Button8Click(Sender: TObject);
var
  _SollLaenge: Integer;
begin
  BeginHourGlass;
  _SollLaenge := IB_Query1.FieldByName('ZAEHLER_NR_STELLEN').AsInteger;
  if _SollLaenge < 99 then
  begin
    with IB_Query10 do
    begin
      ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID')
        .AsInteger;
      Open;
      while not(eof) do
      begin
        if (length(FieldByName('ZAEHLER_NUMMER').AsString) <> _SollLaenge) then
        begin
          edit;
          FieldByName('ZAEHLER_NUMMER').AsString :=
            inttostrN(strtoint64(FieldByName('ZAEHLER_NUMMER').AsString),
            _SollLaenge);
          post;
        end;
        next;
      end;
    end;
  end;
  EndHourGlass;
end;

procedure TFormBaustelle.Button9Click(Sender: TObject);
var
  _IstLaenge: Integer;
begin
  _IstLaenge := 0;
  BeginHourGlass;
  with IB_Query10 do
  begin
    ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    Open;
    while not(eof) do
    begin
      //
      _IstLaenge := max(_IstLaenge,
        length(int64tostr(strtoint64def(FieldByName('ZAEHLER_NUMMER')
        .AsString, 0))));
      next;
    end;
    close;
  end;
  EndHourGlass;
  if _IstLaenge = IB_Query1.FieldByName('ZAEHLER_NR_STELLEN').AsInteger then
    ShowMessage('Der angegebene Bedarf ist korrekt!')
  else if doit('Es wurde ein Bedarf von ' + inttostr(_IstLaenge) + ' ermittelt!'
    + #13 + 'Soll dieser Wert in diese Baustelle eingetragen werden?' + #13 +
    'Eine Anpassung aller Zählernummern erfolgt erst' + #13 +
    'durch die Funktion "übernehmen ...".' + #13 + 'Jetzt den Bedarf eintragen')
  then
  begin
    if (IB_Query1.State <> dssEdit) and (IB_Query1.State <> dssinsert) then
      IB_Query1.edit;
    IB_Query1.FieldByName('ZAEHLER_NR_STELLEN').AsInteger := _IstLaenge;
  end;
end;

procedure TFormBaustelle.VerwaisteHistorischeDatensaetzeLoeschen;
begin
  BeginHourGlass;
  e_x_sql(
    { } 'delete from AUFTRAG A ' +
    { } 'where' +
    { } ' (A.MASTER_R is not null) and' +
    { } ' (A.RID<>A.MASTER_R) and' +
    { } ' (A.BAUSTELLE_R<>' +
    { } '(select B.BAUSTELLE_R from AUFTRAG B where (A.MASTER_R=B.RID))' +
    { } ')');
  EndHourGlass;
end;

procedure TFormBaustelle.WaitFor(s: string);
begin
  StatusBar1.Panels[0].text := s;
end;

procedure TFormBaustelle.Button10Click(Sender: TObject);
begin
  VerwaisteHistorischeDatensaetzeLoeschen;
end;

procedure TFormBaustelle.Button11Click(Sender: TObject);
begin
  BeginHourGlass;
  IB_Query12.close;
  IB_Query12.ParamByName('CROSSREF').assign(IB_Query1.FieldByName('RID'));
  IB_Query12.Open;
  EndHourGlass;
end;

procedure TFormBaustelle.Button12Click(Sender: TObject);
begin
  with IB_DSQL4 do
  begin
    ParamByName('SOURCE').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    ParamByName('DESTINATION').AsInteger := e_r_BaustelleRIDFromKuerzel
      (ComboBox3.text);
    if doit('Wollen Sie wirklich alle Daten nach ' + ComboBox3.text +
      ' verschieben') then
    begin
      BeginHourGlass;
      execute;
      EndHourGlass;
      ShowMessage('Verschieben erfolgreich beendet!');
    end;
  end;
end;

procedure TFormBaustelle.Button13Click(Sender: TObject);
var
  FieldName: string;
  FileName: string;
begin
  FieldName := IB_Memo4.Lines[IB_Memo4.CaretPos.y];
  FileName := cAuftragErgebnisPath + e_r_BaustellenPfad(IB_Memo5.Lines) + '\' +
    FieldName + '.ini';
  // FileName := SAPPath + IB_memo5.lines.values[cE_FTPUSER]+ '\' + FieldName+'.ini';
  if FileExists(FileName) then
  begin
    openShell(FileName);
  end
  else
  begin
    ShowMessage(' Datei "' + FileName + '" nicht gefunden!');
  end;
end;

procedure TFormBaustelle.ComboBox3DropDown(Sender: TObject);
var
  AllTheBaustellen: TStringList;
  k: Integer;
begin
  AllTheBaustellen := e_r_Baustellen;
  k := AllTheBaustellen.indexof
    (e_r_BaustelleKuerzel(IB_Query1.FieldByName('RID').AsInteger));
  if (k <> -1) then
    AllTheBaustellen.Delete(k);
  ComboBox3.items.assign(AllTheBaustellen);
  AllTheBaustellen.free;
end;

procedure TFormBaustelle.IB_Edit7GetDisplayText(Sender: TObject;
  var AString: string);
begin
  AString := secondstostr(StrToIntDef(AString, 0));
end;

procedure TFormBaustelle.IB_Edit7SetEditText(Sender: TObject;
  var AString: string);
begin
  AString := inttostr(StrToSeconds(AString));
end;

procedure TFormBaustelle.IB_Grid4GetDisplayText(Sender: TObject;
  ACol, ARow: Integer; var AString: string);
begin
  if (ARow > 0) then
    if (ACol = 5) then
      if (AString <> '') then
        AString := format('%m', [strtodoubledef(AString, 0.0)]);
end;

procedure TFormBaustelle.IB_Edit7GetEditText(Sender: TObject;
  var AString: string);
begin
  with Sender as TIB_Edit do
    OnGetDisplayText(Sender, AString);
end;

procedure TFormBaustelle.IB_Edit7IsValidChar(Sender: TObject; var AChar: Char;
  var IsValid: Boolean);
begin
  if AChar = ':' then
    IsValid := true;
end;

procedure TFormBaustelle.Button16Click(Sender: TObject);
var
  BAUSTELLE_R: Integer;
  AUFWAND: TAnfixTime;

  CustomAUFWAND: TAnfixTime;
  _CustomAUFWAND: string;
  ART: string;
  AufwandFaktor: double;
  dAUFTRAG: TIB_DSQL;
  n, k: Integer;
begin
  BeginHourGlass;

  // Standard AUfwand setzen
  if (IB_Query1.State = dssEdit) then
    IB_Query1.post;
  InvalidateCache_Baustelle;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  AUFWAND := e_r_EinzelAufwand(BAUSTELLE_R);
  dAUFTRAG := DataModuleDatenbank.nDSQL;
  with dAUFTRAG do
  begin
    sql.Add('update AUFTRAG set');
    sql.Add(' AUFWAND=' + inttostr(AUFWAND));
    sql.Add('where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') AND');
    sql.Add(' ((AUFWAND_SCHUTZ<>''Y'') or (AUFWAND_SCHUTZ IS NULL)) AND');
    sql.Add(' ((AUFWAND<>' + inttostr(AUFWAND) + ') OR (AUFWAND IS NULL))');
    execute;
  end;
  dAUFTRAG.free;

  // Alle anderen AUFWAND setzen
  with IB_Memo6.Lines do
    for n := 0 to pred(count) do
    begin
      k := pos('=', strings[n]);
      if (k > 0) and (k < 5) then
      begin
        ART := nextp(strings[n], '=', 0);
        _CustomAUFWAND := nextp(strings[n], '=', 1);
        if _CustomAUFWAND <> '' then
        begin
          if (pos('%', _CustomAUFWAND) > 0) then
          begin
            // Setzen via Prozentwert
            _CustomAUFWAND := StrFilter(_CustomAUFWAND, '0123456789.,');
            AufwandFaktor := strtodoubledef(_CustomAUFWAND, 0) / 100.0;
            CustomAUFWAND := round(AufwandFaktor * AUFWAND);
          end
          else
          begin
            // Setzen via Fixe Zeit
            CustomAUFWAND := StrToSeconds(_CustomAUFWAND);
          end;

          dAUFTRAG := DataModuleDatenbank.nDSQL;
          with dAUFTRAG do
          begin
            sql.Add('update AUFTRAG set');
            sql.Add(' AUFWAND=' + inttostr(CustomAUFWAND));
            sql.Add('where');
            sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') AND');
            sql.Add(' (ART=''' + ART + ''') AND');
            sql.Add(' ((AUFWAND_SCHUTZ<>''Y'') OR (AUFWAND_SCHUTZ IS NULL))AND');
            sql.Add(' ((AUFWAND<>' + inttostr(CustomAUFWAND) +
              ') OR (AUFWAND IS NULL))');
            execute;
          end;
          dAUFTRAG.free;
        end;
      end;
    end;
  EndHourGlass;
end;

procedure TFormBaustelle.Button14Click(Sender: TObject);
var
  cEXISTS: TIB_Cursor;
  cABLAGE: TIB_Cursor;
  qAUFTRAG: TIB_Query;
  ANZ: Integer;
  BAUSTELLE_R: Integer;
  ZIEL_R: Integer;

  cHauptDatensaetze: TdboClub;
  cHistorischeDatensaetze: TdboClub;

  procedure CopyAll;
  var
    RecN: Integer;
    Starttime: dword;
    n: Integer;
  begin
    with cABLAGE do
    begin
      ProgressBar1.max := RecordCount;
      APiFirst;
      RecN := 0;
      Starttime := 0;
      while not(eof) do
      begin

        repeat

          cEXISTS.ParamByName('CROSSREF').AsInteger := FieldByName('RID')
            .AsInteger;
          cEXISTS.APiFirst;
          if cEXISTS.FieldByName('ANZAHL').AsInteger > 0 then
            break;

          // gibt es den RID schon?
          // die ganzen Columns kopieren
          qAUFTRAG.insert;
          for n := 0 to pred(FieldCount) do
            if Fields[n].IsNotNull then
              qAUFTRAG.FieldByName(Fields[n].FieldName).assign(Fields[n])
            else
              qAUFTRAG.FieldByName(Fields[n].FieldName).clear;

          // Änderungen am Datensatz
          qAUFTRAG.FieldByName('PROTECT_RID').AsInteger := 1;
          if (ZIEL_R <> qAUFTRAG.FieldByName('BAUSTELLE_R').AsInteger) then
            qAUFTRAG.FieldByName('BAUSTELLE_R').AsInteger := ZIEL_R;

          // speichern
          qAUFTRAG.post;

        until true;
        //
        ApiNext;
        inc(RecN);
        if frequently(Starttime, 444) or eof then
        begin
          ProgressBar1.Position := RecN;
          application.processmessages;
        end;

      end;
    end;
  end;

  function SQL_where: string;
  begin
    if (Edit8.text <> '') then
      result := ' (MASTER_R in (' + Edit8.text + ')) '
    else
      result := ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') ';
  end;

begin
  // Vorlauf
  // Ziel-Baustelle für die Reaktivierung!
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  ZIEL_R := StrToIntDef(Edit5.text, BAUSTELLE_R);

  BeginHourGlass;

  // Anzahl der Master-Datensätze ermitteln!
  cABLAGE := DataModuleDatenbank.nCursor;
  with cABLAGE do
  begin
    sql.Add('select count(RID) C_RID from ABLAGE where');
    sql.Add(SQL_where);
    sql.Add(' and (RID=MASTER_R)');
    APiFirst;
    ANZ := FieldByName('C_RID').AsInteger;
  end;
  cABLAGE.free;

  EndHourGlass;

  if doit('Wollen Sie wirklich ' + inttostr(ANZ) + ' Datensätze reaktivieren?')
  then
  begin

    BeginHourGlass;

    // Skript, das die Existenz eines Datensatzes prüfen soll
    cEXISTS := DataModuleDatenbank.nCursor;
    with cEXISTS do
    begin
      sql.Add('select count(RID) ANZAHL from AUFTRAG where RID=:CROSSREF');
    end;

    cHauptDatensaetze := TdboClub.create(cConnection, 'ABLAGE');
    cHauptDatensaetze.sql(
      { } 'select RID from ABLAGE where ' +
      { } SQL_where + 'and ' +
      { } ' (RID=MASTER_R)');

    cHistorischeDatensaetze := TdboClub.create(cConnection, 'ABLAGE');
    cHistorischeDatensaetze.sql(
      { } 'select ABLAGE.RID from ABLAGE ' +
      { } cHauptDatensaetze.join('MASTER_R') +
      { } 'where ' +
      { } ' (ABLAGE.RID<>ABLAGE.MASTER_R)');

    qAUFTRAG := DataModuleDatenbank.nQuery;
    with qAUFTRAG do
    begin
      sql.Add('select * from AUFTRAG for update');
      prepare;
    end;

    // normale Daten
    cABLAGE := DataModuleDatenbank.nCursor;
    with cABLAGE do
    begin

      // Master
      WaitFor('Hauptdatensätze');
      sql.clear;
      sql.Add('select * from ABLAGE');
      sql.Add(cHauptDatensaetze.join);
      CopyAll;

      // Historische
      WaitFor('Historische Datensätze');
      sql.clear;
      sql.Add('select * from ABLAGE');
      sql.Add(cHistorischeDatensaetze.join);
      CopyAll;

    end;
    cABLAGE.free;

    qAUFTRAG.free;
    e_x_commit;
    cHauptDatensaetze.free;
    cHistorischeDatensaetze.free;
    cEXISTS.free;
    if CheckBox41.Checked then
      AblageLoeschen;
    WaitFor('-');
    ProgressBar1.Position := 0;
    EndHourGlass;

    // normale Daten
  end;

end;

procedure TFormBaustelle.Button17Click(Sender: TObject);
var
  cABLAGE: TIB_Cursor;
  ANZ: Integer;
begin
  BeginHourGlass;
  cABLAGE := DataModuleDatenbank.nCursor;
  with cABLAGE do
  begin
    sql.Add('select count(RID) C_RID from ABLAGE where');
    sql.Add('  (BAUSTELLE_R=' + inttostr(IB_Query1.FieldByName('RID').AsInteger)
      + ') AND');
    sql.Add('  (STATUS<>6)');
    APiFirst;
    ANZ := FieldByName('C_RID').AsInteger;
  end;
  cABLAGE.free;
  EndHourGlass;

  if doit('Wollen Sie wirklich ' + inttostr(ANZ) +
    ' Datensätze aus der ABLAGE löschen?') then
    AblageLoeschen;
end;

procedure TFormBaustelle.AblageLoeschen;
var
  dABLAGE: TIB_DSQL;
begin
  BeginHourGlass;
  dABLAGE := DataModuleDatenbank.nDSQL;
  with dABLAGE do
  begin
    // erst die historischen
    sql.Add('delete from ABLAGE where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(IB_Query1.FieldByName('RID').AsInteger)
      + ') AND');
    sql.Add(' (MASTER_R<>RID)');
    execute;
    sql.clear;
    // nun den ganzen Rest
    sql.Add('delete from ABLAGE where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(IB_Query1.FieldByName('RID')
      .AsInteger) + ')');
    execute;
  end;
  dABLAGE.free;
  EndHourGlass;
end;

procedure TFormBaustelle.Button18Click(Sender: TObject);
var
  _pwd: string;
begin
  _pwd := FindANewPassword;
  clipboard.AsText := _pwd;
  ShowMessage('Das generierte Passwort' + #13#10 + _pwd + #13#10 +
    'wurde in die Zwischenablage kopiert!');
end;

procedure TFormBaustelle.Button19Click(Sender: TObject);
var
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  cAUFTRAG: TIB_Cursor;
  qAUFTRAG: TIB_Query;
  cINFO: TIB_Cursor;
  Starttime: dword;
  RecN: Integer;

  cMONTEUR: TIB_Cursor;
  qMONTEUR: TIB_Query;

  //
  SourceTable: string;
  DestTable: string;
  ExceptionCount: Integer;
  RIDl: TgpIntegerList;
  Anz_Inserts: Integer;
  BAUSTELLE_R: Integer; // Zielbaustelle
  ANzMaster: Integer;
  sDiagnose: TStringList;
  PersonBlackList: TStringList;

  function whereSource: string;
  begin
    repeat

      if (Edit4.text <> '') then
      begin
        result := ' (RID_AT_IMPORT=' + Edit4.text + ')';
        break;
      end;

      if (Edit11.text <> '') then
      begin
        result := ' (MASTER_R=' + Edit11.text + ')';
        break;
      end;

      if (Edit14.text <> '') then
      begin
        result := ' (ABLAGE_R=' + Edit14.text + ')';
        break;
      end;

      result := ' (BAUSTELLE_R=' + IB_Query1.FieldByName('RID').AsString + ')';

    until true;
  end;

  procedure InsertData(HauptDatensatz: Boolean);
  var
    n: Integer;
    RID: Integer;
  begin
    Starttime := 0;
    RecN := 0;
    ExceptionCount := 0;

    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      IB_connection := rCONNECTION;
      sql.Add('select * from ' + SourceTable);
      sql.Add('where');
      sql.Add(whereSource);
      if HauptDatensatz then
        sql.Add('and (MASTER_R=RID)')
      else
        sql.Add('and (MASTER_R<>RID)');
      APiFirst;
      while not(eof) do
      begin
        //
        RID := FieldByName('RID').AsInteger;
        if (RIDl.indexof(RID) = -1) then
        begin
          try
            qAUFTRAG.insert;
            for n := 0 to pred(FieldCount) do
              if Fields[n].IsNotNull then
                qAUFTRAG.FieldByName(Fields[n].FieldName).assign(Fields[n])
              else
                qAUFTRAG.FieldByName(Fields[n].FieldName).clear;

            if (BAUSTELLE_R > 0) then
              qAUFTRAG.FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;
            qAUFTRAG.FieldByName('PROTECT_RID').AsInteger := 1;
            qAUFTRAG.FieldByName('POSTLEITZAHL_R').clear;
            qAUFTRAG.post;
            if HauptDatensatz then
              inc(Anz_Inserts);
          except
            on E: Exception do
            begin
              inc(ExceptionCount);
              sDiagnose.Add(cERRORText + ' insert(' + inttostr(RID) + '): ' +
                E.Message);
            end;
          end;
        end;

        inc(RecN);
        next;
        if frequently(Starttime, 1000) or eof then
        begin
          WaitFor(FieldByName('NUMMER').AsString);
          application.processmessages;
        end;

      end;
      close;
    end;
    cAUFTRAG.free;
  end;

var
  n: Integer;

begin
  BeginHourGlass;
  ExceptionCount := 0;
  sDiagnose := TStringList.create;
  PersonBlackList := TStringList.create;

  with PersonBlackList do
  begin
    Add('ZAHLUNGTYP_ER');
    Add('ZAHLUNGTYP_R');
    Add('PRIV_ANSCHRIFT_R');
    Add('GESCH_ANSCHRIFT_R');
  end;

  if CheckBox25.Checked then
    SourceTable := 'ABLAGE'
  else
    SourceTable := 'AUFTRAG';

  if CheckBox34.Checked then
    DestTable := 'ABLAGE'
  else
    DestTable := 'AUFTRAG';

  if (Edit3.text <> '') then
    BAUSTELLE_R := strtol(Edit3.text)
  else
    BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;

  if (Edit4.text <> '') or (Edit11.text <> '') then
    BAUSTELLE_R := -1;

  // bekannte RIDs ausklammern
  WaitFor('Vorlauf ...');
  application.processmessages;
  RIDl := e_r_sqlm('select RID from ' + DestTable + ' where (BAUSTELLE_R=' +
    inttostr(BAUSTELLE_R) + ')');

  //
  rTRANSACTION := TIB_Transaction.create(self);
  with rTRANSACTION do
  begin
    Isolation := tiCommitted;
    AutoCommit := true;
    ReadOnly := true;
  end;

  //
  rCONNECTION := TIB_Connection.create(self);
  with rCONNECTION do
  begin
    DefaultTransaction := rTRANSACTION;
    LoginDBReadOnly := true;
    Protocol := cpTCP_IP;
    DataBaseName := RestoreFName;
    UserName := 'SYSDBA';
    password := deCrypt_Hex(iDataBase_SYSDBA_pwd);
  end;

  with rTRANSACTION do
  begin
    IB_connection := rCONNECTION;
  end;

  rCONNECTION.connect;

  // Vorlauf Quelle
  cINFO := DataModuleDatenbank.nCursor;
  with cINFO do
  begin
    IB_connection := rCONNECTION;
    sql.Add('select count(rid) from ' + SourceTable);
    sql.Add('where');
    sql.Add(whereSource);
    sql.Add(' and (RID=MASTER_R)');
    APiFirst;
    ANzMaster := Fields[0].AsInteger;
  end;
  cINFO.free;

  if doit(inttostr(ANzMaster) + ' Datensätze reaktivieren', true) then
  begin
    // Monteure sicherstellen
    cMONTEUR := DataModuleDatenbank.nCursor;
    qMONTEUR := DataModuleDatenbank.nQuery;
    with qMONTEUR do
    begin
      sql.Add('select * from PERSON for UPDATE');
      Open;
    end;

    //
    with cMONTEUR do
    begin

      //
      // select
      // *
      // from
      // PERSON
      // where
      // (RID in (select distinct MONTEUR1_R from AUFTRAG where AUFTRAG.BAUSTELLE_R=108)) or
      // (RID in (select distinct MONTEUR2_R from AUFTRAG where AUFTRAG.BAUSTELLE_R=108))
      // for update
      //
      IB_connection := rCONNECTION;
      sql.Add('select');
      sql.Add(' *');
      sql.Add('from');
      sql.Add(' PERSON');
      sql.Add('where');
      sql.Add(' (RID in (select distinct MONTEUR1_R from ' + SourceTable +
        ' where ' + whereSource + ')) or');
      sql.Add(' (RID in (select distinct MONTEUR2_R from ' + SourceTable +
        ' where ' + whereSource + '))');
      Open;
      APiFirst;
      while not(eof) do
      begin
        if not(qMONTEUR.locate('RID', FieldByName('RID').AsInteger, [])) then
        begin
          qMONTEUR.insert;
          for n := 0 to pred(FieldCount) do
            if Fields[n].IsNotNull and
              (PersonBlackList.indexof(Fields[n].FieldName) = -1) then
              qMONTEUR.FieldByName(Fields[n].FieldName).assign(Fields[n])
            else
              qMONTEUR.FieldByName(Fields[n].FieldName).clear;
          qMONTEUR.post;
        end;
        ApiNext;
      end;

    end;
    cMONTEUR.free;
    qMONTEUR.free;

    qAUFTRAG := DataModuleDatenbank.nQuery;
    with qAUFTRAG do
    begin
      sql.Add('select * from ' + DestTable + ' for update');
      Open;
    end;
    Anz_Inserts := 0;
    if CheckBox38.Checked then
      InsertData(true);
    if CheckBox39.Checked then
      InsertData(false);
    qAUFTRAG.close;
    qAUFTRAG.free;
  end;

  sDiagnose.SaveToFile(DiagnosePath + 'Baustelle-Restore.txt');

  RIDl.free;
  sDiagnose.free;
  PersonBlackList.free;
  EndHourGlass;

  ShowMessage(inttostr(Anz_Inserts) + ' Datensätze eingefügt!' + #13 +
    inttostr(ExceptionCount) + ' Fehler!');

  if (ExceptionCount > 0) then
    openShell(DiagnosePath + 'Baustelle-Restore.txt');

end;

procedure TFormBaustelle.Button20Click(Sender: TObject);

  procedure EnsureEntry(EntryName: string; Lines: TStrings);
  begin
    if Lines.values[EntryName] = '' then
    begin
      Lines.values[EntryName] := '';
      Lines.Add(EntryName + '=');
    end;
  end;

begin
  EnsureEntry(cE_FTPHOST, IB_Memo5.Lines);
  EnsureEntry(cE_FTPUSER, IB_Memo5.Lines);
  EnsureEntry(cE_FTPPASSWORD, IB_Memo5.Lines);
  EnsureEntry(cE_FTPVerzeichnis, IB_Memo5.Lines);
  EnsureEntry(cE_VERZEICHNIS, IB_Memo5.Lines);
  EnsureEntry(cE_ZIPPASSWORD, IB_Memo5.Lines);
  EnsureEntry(cE_XLSVorlage, IB_Memo5.Lines);
  EnsureEntry(cE_SAPQUELLE, IB_Memo5.Lines);
  EnsureEntry(cE_SAPReihenfolge, IB_Memo5.Lines);
  EnsureEntry(cE_SpaltenAlias, IB_Memo5.Lines);
  EnsureEntry(cE_ZusaetzlicheZips, IB_Memo5.Lines);
  EnsureEntry(cE_Praefix, IB_Memo5.Lines);
  EnsureEntry(cE_MaxperLoad, IB_Memo5.Lines);
  EnsureEntry(cE_MaterialNummerAlt, IB_Memo5.Lines);
  EnsureEntry(cE_MaterialNummerNeu, IB_Memo5.Lines);
  EnsureEntry(cE_Zaehlwerk, IB_Memo5.Lines);
  EnsureEntry(cE_ZaehlwerkNeu, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsCSV, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsXML, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsXLS, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsXLSunmoeglich, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsKK22, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsARGOS, IB_Memo5.Lines);
  EnsureEntry(cE_OhneStandardXLS, IB_Memo5.Lines);
  EnsureEntry(cE_EinsZuEins, IB_Memo5.Lines);
  EnsureEntry(cE_EineDatei, IB_Memo5.Lines);
  EnsureEntry(cE_Filter, IB_Memo5.Lines);
  EnsureEntry(cE_ZaehlerNummerNeuZeichen, IB_Memo5.Lines);
  EnsureEntry(cE_ZaehlerNummerNeuAusN1, IB_Memo5.Lines);
  EnsureEntry(cE_ZaehlerNummerNeuMitA1, IB_Memo5.Lines);
  EnsureEntry(cE_eMail, IB_Memo5.Lines);
  EnsureEntry(cE_Wochentage, IB_Memo5.Lines);
  EnsureEntry(cE_ZipAnlage, IB_Memo5.Lines);
  EnsureEntry(cE_AuchAlsIDOC, IB_Memo5.Lines);
  EnsureEntry(cE_QS_Mode, IB_Memo5.Lines);
  EnsureEntry(cE_SQL_Filter, IB_Memo5.Lines);
  EnsureEntry(cE_Datenquelle, IB_Memo5.Lines);
  EnsureEntry(cE_AbschlussTransaktion, IB_Memo5.Lines);
  EnsureEntry(cE_KopieVon, IB_Memo5.Lines);
  EnsureEntry(cE_FotoQuelle, IB_Memo5.Lines);
  EnsureEntry(cE_FotoZiel, IB_Memo5.Lines);
  EnsureEntry(cE_FotosMaxAnzahl, IB_Memo5.Lines);
  EnsureEntry(cE_FotoAblage, IB_Memo5.Lines);
  EnsureEntry(cE_FotoBenennung, IB_Memo5.Lines);
  EnsureEntry(cE_CoreFTP, IB_Memo5.Lines);
  EnsureEntry(cE_AuchMitFoto, IB_Memo5.Lines);
  EnsureEntry(cE_SpaltenOhneInhalt, IB_Memo5.Lines);
  EnsureEntry(cE_SpalteAlsText, IB_Memo5.Lines);
end;

procedure TFormBaustelle.Button21Click(Sender: TObject);
var
  xAUFTRAG: TIB_DSQL;
begin
  if doit('TAN zurücksetzen, und Daten als' + #13 + 'ungesendet betrachten')
  then
  begin
    BeginHourGlass;

    // TANs austragen
    xAUFTRAG := DataModuleDatenbank.nDSQL;
    with xAUFTRAG do
    begin
      sql.Add('update');
      sql.Add(' auftrag');
      sql.Add('set');
      sql.Add(' export_tan= null');
      sql.Add('where');
      sql.Add(' (export_tan=' + IB_Query1.FieldByName('EXPORT_TAN').AsString
        + ') AND');
      sql.Add(' (BAUSTELLE_R=' + IB_Query1.FieldByName('RID').AsString + ')');
      execute;
    end;

    // Um eines zurücksetzen
    xAUFTRAG.free;
    IB_Query1.FieldByName('EXPORT_TAN').AsInteger :=
      pred(IB_Query1.FieldByName('EXPORT_TAN').AsInteger);
    IB_Query1.post;
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  InvalidateCache_Baustelle;
end;

procedure TFormBaustelle.ReflectZustaendige;
begin
  ComboBox1.text := FormBearbeiter.FetchKURZFromRID
    (IB_Query1.FieldByName('BEARBEITUNG_R').AsInteger);
  ComboBox6.text := FormBearbeiter.FetchKURZFromRID
    (IB_Query1.FieldByName('VERTRETUNG_R').AsInteger);
end;

procedure TFormBaustelle.ReadState;
var
  I: Integer;
begin
  I := IB_Query1.FieldByName('BUNDESLAND_IDX').AsInteger;
  if I < 0 then
    I := 0;
  if I < ComboBox7.items.count then
    ComboBox7.ItemIndex := I;
end;

procedure TFormBaustelle.ReflectArbeitszeitInfo;
var
  Gesamt: double;
  REGEL_ARBEITSZEIT_V: Integer;
  REGEL_ARBEITSZEIT_N: Integer;
begin
  with IB_Query1 do
  begin
    Gesamt := FieldByName('LAST_V').AsInteger + FieldByName('LAST_N').AsInteger;
    if (Gesamt > 0) then
    begin
      REGEL_ARBEITSZEIT_V := round(iTagesArbeitszeit * FieldByName('LAST_V')
        .AsInteger / Gesamt);
      REGEL_ARBEITSZEIT_N := round(iTagesArbeitszeit * FieldByName('LAST_N')
        .AsInteger / Gesamt);
      if FieldByName('REGEL_ARBEITSZEIT_V').AsInteger <> REGEL_ARBEITSZEIT_V
      then
        FieldByName('REGEL_ARBEITSZEIT_V').AsInteger := REGEL_ARBEITSZEIT_V;
      if FieldByName('REGEL_ARBEITSZEIT_N').AsInteger <> REGEL_ARBEITSZEIT_N
      then
        FieldByName('REGEL_ARBEITSZEIT_N').AsInteger := REGEL_ARBEITSZEIT_N;
    end;
  end;
end;


procedure TFormBaustelle.ReflectFotoPath;
begin
  Label62.caption := FotoPath + e_r_BaustellenPfadFoto(IB_Memo5.Lines) + '\';
  Label63.caption := FotoPath + e_r_BaustellenPfad(IB_Memo5.Lines) + '\';
end;

procedure TFormBaustelle.IB_Edit3Change(Sender: TObject);
begin
  ReflectArbeitszeitInfo;
end;

procedure TFormBaustelle.IB_Edit4Change(Sender: TObject);
begin
  ReflectArbeitszeitInfo;
end;

procedure TFormBaustelle.Button15Click(Sender: TObject);
var
  cAUFTRAEGE: TIB_Cursor;
  ARTEN: TStringList;
  Settings: TSearchStringList;
begin
  BeginHourGlass;
  Settings := TSearchStringList.create;
  ARTEN := TStringList.create;
  cAUFTRAEGE := DataModuleDatenbank.nCursor;
  with cAUFTRAEGE do
  begin
    sql.Add('select distinct ART from AUFTRAG where');
    sql.Add(' (BAUSTELLE_R=' + IB_Query1.FieldByName('RID').AsString + ') AND');
    sql.Add(' (STATUS<>' + inttostr(ord(ctsHistorisch)) + ')');
    APiFirst;
    while not(eof) do
    begin
      ARTEN.Add(FieldByName('ART').AsString);
      ApiNext;
    end;
  end;
  cAUFTRAEGE.free;
  Settings.assign(IB_Memo6.Lines);
  if Settings.EnsureValues(ARTEN) then
    IB_Memo6.Lines.assign(Settings);
  Settings.free;
  ARTEN.free;
  EndHourGlass;
end;

procedure TFormBaustelle.Button22Click(Sender: TObject);
begin
  ShowMessage(RestoreFName);
end;

procedure TFormBaustelle.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Baustelle');
end;

procedure TFormBaustelle.LogFoto(s: string);
begin
  with ListBox1 do
  begin
    items.Add(s);
    ItemIndex := pred(items.count);
  end;
  application.processmessages;
end;

procedure TFormBaustelle.LogFoto(s: TStringList);
var
  I: Integer;
begin
  for I := 0 to pred(s.count) do
    LogFoto(s[I]);
end;

procedure TFormBaustelle.SpeedButton10Click(Sender: TObject);
const
  cBildFName = 'Bilder.ini';
var
  LokaleBilder: TStringList;
  RemoteBilder: TStringList;
  RemoteFotos: TStringList;
  RemoteBilderUnbenannt: TStringList;
  ZipOptions: TStringList;
  WorkPath: string;
  FotoFTP: TIdFTP;
  Settings: TStringList;
  n: Integer;
  ZipFileCount: Integer;
  LocalFSize, RemoteFSize: Int64;
begin
  //
  NoTimer := true;
  if (FotoPath <> '') then
  begin
    BeginHourGlass;

    ListBox1.items.clear;

    LokaleBilder := TStringList.create;
    RemoteBilder := TStringList.create;
    RemoteFotos := TStringList.create;
    RemoteBilderUnbenannt := TStringList.create;
    Settings := TStringList.create;
    ZipOptions := TStringList.create;
    FotoFTP := TIdFTP.create;

    // checks
    Settings.AddStrings(IB_Memo5.Lines);
    CheckCreateDir(FotoPath);
    WorkPath := FotoPath + e_r_BaustellenPfadFoto(Settings) + '\';
    CheckCreateDir(WorkPath);
    if FileExists(WorkPath + cBildFName) then
      LokaleBilder.LoadFromFile(WorkPath + cBildFName);

    SolidInit(FotoFTP);
    with FotoFTP do
    begin
      OnWork := IdFTP1Work;
      OnWorkBegin := IdFTP1WorkBegin;
      OnWorkEnd := IdFTP1WorkEnd;
      Host := e_r_ParameterFoto(Settings, cE_FTPHOST);
      UserName := nextp(e_r_ParameterFoto(Settings, cE_FTPUSER), '\', 0);
      password := e_r_ParameterFoto(Settings, cE_FTPPASSWORD);
    end;
    ZipOptions.Add('Password=' + e_r_ParameterFoto(Settings, cE_ZIPPASSWORD));

    SolidBeginTransaction;
    try
      // Check if some news ...
      SolidDir(FotoFTP, '', '*-Bilder.zip','????-Bilder.zip', RemoteBilder);
      SolidDir(FotoFTP, '', 'Fotos-*.zip','Fotos-????.zip', RemoteFotos);
      SolidDir(FotoFTP, '', '*-Bilder_Unbenannt.zip','????-Bilder_Unbenannt.zip', RemoteBilderUnbenannt);
      RemoteBilder.AddStrings(RemoteBilderUnbenannt);
      RemoteBilder.AddStrings(RemoteFotos);
      for n := 0 to pred(RemoteBilder.count) do
      begin
        if (LokaleBilder.values[RemoteBilder[n]] = '') then
        begin

          // Prüfen ob es die Datei ev. schon gibt
          LocalFSize := FSize(WorkPath + RemoteBilder[n]);

          if (LocalFSize > cFSize_NotExists) then
            RemoteFSize := SolidSize(FotoFTP, '', RemoteBilder[n])
          else
            RemoteFSize := cFSize_Null;

          if (LocalFSize = RemoteFSize) then
          begin
            ListBox1.items.Add('skip ' + RemoteBilder[n] + ' ...');
            LokaleBilder.values[RemoteBilder[n]] := inttostr(0) + ';' +
              sTimeStamp;
            LokaleBilder.SaveToFile(WorkPath + cBildFName);
            application.processmessages;
            continue;
          end;

          //
          ListBox1.items.Add('lade ' + RemoteBilder[n] + ' ...');
          application.processmessages;

          //
          if SolidGet(FotoFTP, '', RemoteBilder[n], '', WorkPath) then
          begin
            ZipFileCount := unzip(WorkPath + RemoteBilder[n], WorkPath,
              ZipOptions);
            if (ZipFileCount > 0) then
            begin
              LokaleBilder.values[RemoteBilder[n]] := inttostr(ZipFileCount) +
                ';' + sTimeStamp;
              LokaleBilder.SaveToFile(WorkPath + cBildFName);
            end;
          end;
        end;
      end;
      ListBox1.items.Add('OK');
    except
      on E: Exception do
      begin
        solidLog(cERRORText + ' Fotos laden: ' + E.Message);
      end;
    end;
    SolidEndTransaction;

    //
    LokaleBilder.free;
    RemoteBilder.free;
    RemoteFotos.free;
    RemoteBilderUnbenannt.free;
    Settings.free;
    ZipOptions.free;
    FotoFTP.free;

    EndHourGlass;
  end;
  NoTimer := false;

end;

procedure TFormBaustelle.SpeedButton11Click(Sender: TObject);
var
  RemoteXML: TStringList;
  WorkPath: string;
  FTP: TIdFTP;
  Settings: TStringList;
  n: Integer;
  SicherungsFName: string;

  function validate(FName: string): Boolean;
  var
    sBericht: TStringList;
    n: Integer;
  begin
    sBericht := TStringList.create;
    DoConversion(Content_Mode_dtd, FName, sBericht);
    result := true;
    for n := 0 to pred(sBericht.count) do
      if pos(cERRORText, sBericht[n]) > 0 then
      begin
        result := false;
        break;
      end;
    sBericht.free;
  end;

  procedure Log(s: string);
  begin
    ListBox2.items.Add(s);
    application.processmessages;
  end;

  function XMLSicherungenPfad: string;
  begin
    result := ValidatePathName(iCSVOpenPath) + '\' + 'EXPORT\';
  end;

  function StampFName(FName: string): string;
  begin
    result := FName;
    ersetze('.xml', '-' + inttostr(e_w_GEN('EREIGNIS_GID')) + '.xml', result);
  end;

begin
  //
  NoTimer := true;
  BeginHourGlass;

  ListBox2.items.clear;
  RemoteXML := TStringList.create;
  Settings := TStringList.create;
  FTP := TIdFTP.create;

  // checks
  Settings.AddStrings(IB_Memo5.Lines);
  WorkPath := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\';
  CheckCreateDir(WorkPath);
  CheckCreateDir(XMLSicherungenPfad);

  SolidInit(FTP);
  SolidFTP_NonLinuxParser := true;
  with FTP do
  begin
    Host := Settings.values[cE_FTPHOST];
    UserName := nextp(Settings.values[cE_FTPUSER], '\', 0);
    password := Settings.values[cE_FTPPASSWORD];
  end;

  SolidBeginTransaction;

  try
    // Check if some news ...
    SolidDir(FTP, Settings.values[cE_FTPVerzeichnis], '*.xml', '', RemoteXML);
    for n := 0 to pred(RemoteXML.count) do
    begin
      //
      Log('lade ' + RemoteXML[n] + ' ...');
      //
      if SolidGet(FTP, Settings.values[cE_FTPVerzeichnis], RemoteXML[n], '',
        WorkPath) then
      begin
        Log('validiere ' + RemoteXML[n] + ' ...');
        if validate(WorkPath + RemoteXML[n]) then
        begin
          SicherungsFName := XMLSicherungenPfad + StampFName(RemoteXML[n]);
          // Sicherheitskopie anlegen
          if FileCopy(WorkPath + RemoteXML[n], SicherungsFName) then
          begin

            // Auf der FTP Ablage löschen
            SolidDel(FTP, Settings.values[cE_FTPVerzeichnis], RemoteXML[n]);
          end
          else
          begin
            Log(
              { } cERRORText +
              { } ' Sicherungskopie "' +
              { } SicherungsFName +
              { } '"konnte nicht erstellt werden');
          end;
        end
        else
        begin
          Log(cERRORText + ' Validierung war nicht erfolgreich');
        end;
      end
      else
      begin
        Log(cERRORText + ' Herunterladen nicht gelungen');
      end;
    end;
    Log('ENDE');
  except
    on E: Exception do
    begin
      solidLog(cERRORText + ' AufträgeLaden: ' + E.Message);
    end;
  end;
  SolidEndTransaction;

  //
  RemoteXML.free;
  Settings.free;
  FTP.free;

  EndHourGlass;

  NoTimer := false;
end;

procedure TFormBaustelle.SpeedButton13Click(Sender: TObject);
begin
  FormFotoMeldung.show;
end;

procedure TFormBaustelle.SpeedButton14Click(Sender: TObject);
var
  sBaustelle: string;
  sPath: string;
begin
  sBaustelle := IB_Query1.FieldByName('NUMMERN_PREFIX').AsString;
  if (sBaustelle <> '') then
  begin
    CheckCreateDir(iBaustellenPath + sBaustelle);
    sPath := e_r_BaustelleFotoPath(IB_Query1.FieldByName('RID').AsInteger);
    CheckCreateDir(sPath);
    openShell(sPath);
  end;
end;

procedure TFormBaustelle.SpeedButton15Click(Sender: TObject);
var
  ImportL: TStringList;
  n: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);
    for n := 1 to pred(ImportL.count) do
      e_x_sql('update AUFTRAG set ZAEHLER_NUMMER=''' + nextp(ImportL[n], ';', 0)
        + ''' where ' + ' (ZAEHLER_NUMMER=''' + nextp(ImportL[n], ';', 1) +
        ''') AND' + ' (BAUSTELLE_R=' + IB_Query1.FieldByName('RID')
        .AsString + ')');
    ImportL.free;
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.SpeedButton16Click(Sender: TObject);
var
  s: TStringList;
  FName: string;
  n, k, l: Integer;
begin
  //
  s := TStringList.create;
  FName :=
  { } MyProgramPath +
  { } cProtokollPath +
  { } IB_Query1.FieldByName('NUMMERN_PREFIX').AsString +
  { } Edit13.text +
  { } cProtExtension;
  if FileExists(FName) then
  begin
    s.LoadFromFile(FName);
    for n := 0 to pred(s.count) do
    begin
      k := pos('=', s[n]);
      if k > 0 then
      begin
        l := length(s[n]);
        if l > 2 then
        begin
          if (k = l) then
            if (StrFilter(s[n][1], cZiffern) = '') then
            begin
              Memo1.Lines.Add(copy(s[n], 1, pred(l)));
            end;
        end;
      end;
    end;
  end
  else
  begin
    ShowMessage(FName + ' nicht gefunden!');
  end;
  s.free;
end;

procedure TFormBaustelle.SpeedButton17Click(Sender: TObject);
var
  IdFTP1: TIdFTP;
begin
  BeginHourGlass;

  // Baustelle.csv erstellen
  e_r_Sync_Baustelle;

  // Datei hochladen
  IdFTP1 := TIdFTP.create(self);
  SolidFTP_Retries := 5;
  SolidInit(IdFTP1);
  with IdFTP1 do
  begin
    Host := nextp(iMobilFTP, ';', 0);
    UserName := nextp(iMobilFTP, ';', 1);
    password := nextp(iMobilFTP, ';', 2);
  end;

  SolidBeginTransaction;
  SolidPut(IdFTP1, MdePath + cServiceFoto_BaustelleFName, '', cServiceFoto_BaustelleFName);
  SolidEndTransaction;

  try
    IdFTP1.Disconnect;
  except
  end;

  try
    IdFTP1.free;
  except
  end;

  EndHourGlass;
end;

procedure TFormBaustelle.SpeedButton18Click(Sender: TObject);
begin
  BeginHourGlass;
  e_r_Sync_Auftraege(IB_Query1.FieldByName('RID').AsInteger);
  EndHourGlass;
end;

procedure TFormBaustelle.SpeedButton19Click(Sender: TObject);
var
  sPath: string;
begin
  sPath := AuftragMobilServerPath + e_r_BaustelleKuerzel
    (IB_Query1.FieldByName('RID').AsInteger) + '\';
  CheckCreateDir(sPath);
  openShell(sPath);
end;

procedure TFormBaustelle.SpeedButton1Click(Sender: TObject);
begin
  FormAuftragImport.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.SpeedButton20Click(Sender: TObject);
begin
  FormKontext.cnBAUSTELLE.addContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.SpeedButton21Click(Sender: TObject);
var
  BAUSTELLE_R: Integer;
begin
  with IB_Query1 do
  begin
    if not(Active) then
      Open;
    if State in [dssinsert, dssEdit] then
      post;
    BAUSTELLE_R := IB_Query1.Gen_ID('GEN_BAUSTELLE', 1);
    insert;
    FieldByName('RID').AsInteger := BAUSTELLE_R;
    ClearMonteurZuordnung;
    post;
    InvalidateCache_Baustelle;
    refreshall;
    locate('RID', BAUSTELLE_R, []);
  end;
end;

procedure TFormBaustelle.SpeedButton2Click(Sender: TObject);
begin
  FormAuftragBildzuordnung.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.SpeedButton3Click(Sender: TObject);
begin
  FormBaustelleFoto.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBaustelle.SpeedButton4Click(Sender: TObject);
var
  sBaustelle: string;
begin
  sBaustelle := IB_Query1.FieldByName('NUMMERN_PREFIX').AsString;
  if (sBaustelle <> '') then
  begin
    CheckCreateDir(iBaustellenPath + sBaustelle);
    openShell(iBaustellenPath + sBaustelle);
  end;
end;

procedure TFormBaustelle.SpeedButton5Click(Sender: TObject);

const
  cFotoPath: string = '';
  cFotoZiel: string = '';

var
  BAUSTELLE_R: Integer;
  iMaxAnzahlBilder: Integer;
  RemoteServerError: Boolean;
  Stat_AnzahlFotos: Integer;
  Stat_AnzahlFotosErkannt: Integer;

  procedure Proceed(iGeraet: string);
  const
    cFotoQuelle: string = '';
  var
    sBilder: TStringList;
    sBilderSorter: TStringList;
    sParameter: TStringList;
    sWechsel: TStringList;
    n: Integer;
    iEXIF: TExifData;
    AufnahmeMoment: TDateTime;

    // Verarbeitungs-Algo
    AutomataState: Integer;
    BildIndex: Integer;
    Line: string;
    WechselDatum: TANFIXDAte;
    WechselUhr: TAnfixTime;
    AUFTRAG_R: Integer;
    BildDatum: TANFIXDAte;
    BildUhr: TAnfixTime;
    AnzahlBilder: Integer;
    FotoOffset: double; // Für fehlerhafte Nokia 6303c

    // Meldung an OrgaMon
    MeldungsTAN: string;
    sMeldung: TStringList;

    // Lokale Statistik
    lStat_AnzahlFotos: Integer;
    lStat_AnzahlFotosErkannt: Integer;

    procedure setWechselOptions(s: string);
    var
      Options: TStringList;
    begin
      Options := split(nextp(s, ';', 5), cProtokollTrenner);
      //
      iMaxAnzahlBilder := StrToIntDef(Options.values['MaxAnzahl'], 2);

      Options.free;
    end;

    function getWechselPrefix(s: string): string;
    var
      Options: TStringList;
      n: Integer;
    begin
      Options := split(nextp(s, ';', 5), cProtokollTrenner);
      for n := pred(Options.count) downto 0 do
        if pos('=', Options[n]) > 0 then
          Options.Delete(n);
      if (Options.count > 0) then
        result := noblank(Options[0])
      else
        result := '';
      Options.free;
    end;

    function NeuerDateiName(WechselIndex: Integer; Rang: Integer): string;
    begin
      if (Rang = 0) then
      begin
        result :=
        { Prefix } getWechselPrefix(sWechsel[WechselIndex]) +
        { Z#Ausbau } nextp(sWechsel[WechselIndex], ';', 3) +
        { } '.jpg';
      end
      else
      begin
        if iMaxAnzahlBilder = 2 then
          result :=
          { Prefix } getWechselPrefix(sWechsel[WechselIndex]) +
          { Z#Ausbau } nextp(sWechsel[WechselIndex], ';', 3) +
          { } '-Neu-' +
          { Z#Einbau } nextp(sWechsel[WechselIndex], ';', 4) +
          { } '.jpg'
        else
          result :=
          { } getWechselPrefix(sWechsel[WechselIndex]) +
          { } nextp(sWechsel[WechselIndex], ';', 3) +
          { } '-' + inttostrN(Rang, 2) + '-' +
          { } nextp(sWechsel[WechselIndex], ';', 4) + '.jpg';
      end;
    end;

    procedure proceedMeldung;
    var
      sREST: TStringList;
    begin
      sREST := DataModuleREST.REST(
        { host } iJonDaServer + 'up.php?' +
        { proceed } 'proceed=' + MeldungsTAN);
      sREST.free;
    end;

    procedure initMeldung;
    var
      sREST: TStringList;
    begin
      // versuchen eine TAN zu erhalten
      sREST := DataModuleREST.REST(
        { host } iJonDaServer + 'up.php?' +
        { id } 'id=' +
        { Geräte ID } iGeraet + ';' +
        { letzte TAN } '00000' + ';' +
        { Programm-Version } RevToStr(globals.Version) + ';' +
        { Optionen } 'Foto' + ';' +
        { Timestamp } Datum10 + ' - ' + Uhr8);

      MeldungsTAN := ExtractSegmentBetween(HugeSingleLine(sREST, ''), '<BODY>',
        '</BODY>', true);
      sREST.free;

      if length(MeldungsTAN) <> 5 then
      begin
        ShowMessage(MeldungsTAN);
        MeldungsTAN := '';
      end;

    end;

    function checkMeldung(sREST: TStringList): Boolean;
    begin
      if assigned(sREST) then
        result := (pos('<BODY>OK</BODY>', HugeSingleLine(sREST, '')) > 0)
      else
        result := false;
    end;

    function prefixMDE: string;
    begin
      result :=
      { RID } inttostr(AUFTRAG_R) +
      { Leerfelder } ';;;;;;;';
    end;

    function toProtokoll(NewName: string; SorterIndex: Integer): string;
    var
      iBild: Integer;
      Line: string;
    begin
      Line := sBilderSorter[SorterIndex];
      iBild := Integer(sBilderSorter.objects[SorterIndex]);
      result :=
      { Neuer Bilddateiname } NewName + ',' +
      { Datum } long2date(StrToIntDef(copy(Line, 1, 8), 0)) + ',' +
      { Uhr } copy(Line, 10, 8) + ',' +
      { FileSize } inttostr(FSize(cFotoQuelle + sBilder[iBild]));
    end;

    procedure Move1(SorterIndex: Integer);
    var
      iBild, iWechsel: Integer;
      NewNameA: string;
      MeldungsZeile: string;
      sREST: TStringList;
    begin
      // Schon eine Meldungs-TAN erhalten?
      if (MeldungsTAN = '') then
        initMeldung;

      if (MeldungsTAN <> '') then
      begin

        iWechsel := Integer(sBilderSorter.objects[SorterIndex - 1]);
        NewNameA := NeuerDateiName(iWechsel, 0);

        // Meldung machen!
        MeldungsZeile := prefixMDE + 'FA=' + toProtokoll(NewNameA, SorterIndex);
        sREST := DataModuleREST.REST(
          { host } iJonDaServer + 'up.php?' +
          { TAN } 'tan=' + MeldungsTAN + '&' +
          { data } 'data=' + MeldungsZeile);
        sMeldung.Add(MeldungsZeile);
        if checkMeldung(sREST) then
        begin

          // Ausbau
          iBild := Integer(sBilderSorter.objects[SorterIndex]);
          LogFoto('Erkannt: ' + NewNameA);
          if FileCopy(cFotoQuelle + sBilder[iBild], cFotoZiel + NewNameA) then
          begin
            FileDelete(cFotoQuelle + sBilder[iBild]);
            inc(Stat_AnzahlFotosErkannt);
            inc(lStat_AnzahlFotosErkannt);
          end;
        end
        else
        begin
          LogFoto(cERRORText + ' Meldung ging schief!');
          RemoteServerError := true;
        end;

        sREST.free;
      end
      else
      begin
        LogFoto(cERRORText + ' keine TAN erhalten!');
        RemoteServerError := true;
      end;

    end;

    procedure Move2(SorterIndex: Integer);
    var
      iBild, iWechsel: Integer;
      NewNameA: string;
      NewNameN: string;
      MeldungsZeile: string;
      sREST: TStringList;
    begin
      //
      if MeldungsTAN = '' then
        initMeldung;

      if (MeldungsTAN <> '') then
      begin
        iWechsel := Integer(sBilderSorter.objects[SorterIndex - 2]);
        NewNameA := NeuerDateiName(iWechsel, 0);
        NewNameN := NeuerDateiName(iWechsel, 1);

        // Meldung machen!
        MeldungsZeile :=
        { Prolog } prefixMDE +
        { Ausbau } 'FA=' + toProtokoll(NewNameA, SorterIndex - 1) + '~' +
        { Einbau } 'FN=' + toProtokoll(NewNameN, SorterIndex);
        sREST := DataModuleREST.REST(
          { host } iJonDaServer + 'up.php?' +
          { TAN } 'tan=' + MeldungsTAN + '&' +
          { data } 'data=' + MeldungsZeile);
        sMeldung.Add(MeldungsZeile);
        if checkMeldung(sREST) then
        begin
          // Ausbau
          iBild := Integer(sBilderSorter.objects[SorterIndex - 1]);
          LogFoto('Erkannt: ' + NewNameA);
          if FileCopy(cFotoQuelle + sBilder[iBild], cFotoZiel + NewNameA) then
          begin
            FileDelete(cFotoQuelle + sBilder[iBild]);
            inc(Stat_AnzahlFotosErkannt);
            inc(lStat_AnzahlFotosErkannt);
          end;

          // Einbau
          iBild := Integer(sBilderSorter.objects[SorterIndex]);
          LogFoto('Erkannt: ' + NewNameN);
          if FileCopy(cFotoQuelle + sBilder[iBild], cFotoZiel + NewNameN) then
          begin
            FileDelete(cFotoQuelle + sBilder[iBild]);
            inc(Stat_AnzahlFotosErkannt);
            inc(lStat_AnzahlFotosErkannt);
          end;
        end
        else
        begin
          LogFoto(cERRORText + ' Meldung ging schief!');
          RemoteServerError := true;
        end;

        sREST.free;
      end
      else
      begin
        LogFoto(cERRORText + ' keine TAN erhalten!');
        RemoteServerError := true;
      end;

    end;

    procedure MoveN(SorterIndex: Integer; AnzahlBilder: Integer);
    var
      iBild, iWechsel: Integer;
      NewNameA: string;
      NewNameN: string;
      NewNameFF: string;
      MeldungsZeile: string;
      sREST: TStringList;
      n: Integer;
    begin
      //
      if (MeldungsTAN = '') then
        initMeldung;

      if (MeldungsTAN <> '') then
      begin
        iWechsel := Integer(sBilderSorter.objects[SorterIndex - 2]);
        NewNameA := NeuerDateiName(iWechsel, 0);
        NewNameN := NeuerDateiName(iWechsel, 1);

        // Meldung machen!
        MeldungsZeile :=
        { Prolog } prefixMDE +
        { Ausbau } 'FA=' + toProtokoll(NewNameA, SorterIndex - 1) + '~' +
        { Einbau } 'FN=' + toProtokoll(NewNameN, SorterIndex) + '~' +
        { Weitere } 'FF=' + inttostr(AnzahlBilder);

        // REST
        sREST := DataModuleREST.REST(
          { host } iJonDaServer + 'up.php?' +
          { TAN } 'tan=' + MeldungsTAN + '&' +
          { data } 'data=' + MeldungsZeile);
        sMeldung.Add(MeldungsZeile);
        if checkMeldung(sREST) then
        begin
          // Ausbau
          iBild := Integer(sBilderSorter.objects
            [SorterIndex - pred(AnzahlBilder)]);
          LogFoto('Erkannt: ' + NewNameA);
          if FileCopy(cFotoQuelle + sBilder[iBild], cFotoZiel + NewNameA) then
          begin
            FileDelete(cFotoQuelle + sBilder[iBild]);
            inc(Stat_AnzahlFotosErkannt);
            inc(lStat_AnzahlFotosErkannt);
          end;

          // Alle weiteren
          for n := AnzahlBilder - 2 downto 0 do
          begin
            NewNameFF := NeuerDateiName(iWechsel, pred(AnzahlBilder - n));
            iBild := Integer(sBilderSorter.objects[SorterIndex - n]);
            LogFoto('Erkannt: ' + NewNameFF);
            if FileCopy(cFotoQuelle + sBilder[iBild], cFotoZiel + NewNameFF)
            then
            begin
              FileDelete(cFotoQuelle + sBilder[iBild]);
              inc(Stat_AnzahlFotosErkannt);
              inc(lStat_AnzahlFotosErkannt);
            end;
          end;

        end
        else
        begin
          LogFoto(cERRORText + ' Meldung ging schief!');
          RemoteServerError := true;
        end;

        sREST.free;
      end
      else
      begin
        LogFoto(cERRORText + ' keine TAN erhalten!');
        RemoteServerError := true;
      end;

    end;

    procedure MoveUmbenannt;
    var
      sUmbenannt: TStringList;
      n: Integer;
      MeldungsZeile: string;
      sREST: TStringList;
      NewName: string;
    begin
      if FileExists(cFotoQuelle + 'Umbenannt.txt') then
      begin
        sUmbenannt := TStringList.create;
        sUmbenannt.LoadFromFile(cFotoQuelle + 'Umbenannt.txt');

        if (MeldungsTAN = '') then
          initMeldung;

        if (MeldungsTAN <> '') then
        begin

          for n := 0 to pred(sUmbenannt.count) do
          begin

            if RemoteServerError then
              break;

            // Zeile lesen
            AUFTRAG_R := StrToIntDef(nextp(sUmbenannt[n], ';', 0), cRID_Null);
            NewName := nextp(nextp(sUmbenannt[n], ';', 1), '=', 1);

            // Melden!
            if (AUFTRAG_R >= cRID_FirstValid) then
            begin

              MeldungsZeile :=
              { Prolog } prefixMDE +
              { Ausbau } nextp(sUmbenannt[n], ';', 1);

              sREST := DataModuleREST.REST(
                { host } iJonDaServer + 'up.php?' +
                { TAN } 'tan=' + MeldungsTAN + '&' +
                { data } 'data=' + MeldungsZeile);
              sMeldung.Add(MeldungsZeile);
              if checkMeldung(sREST) then
              begin
                LogFoto('Erkannt: ' + NewName);
              end
              else
              begin
                LogFoto(cERRORText + ' Meldung ging schief!');
                RemoteServerError := true;
              end;

              sREST.free;

            end;
          end;

          if not(RemoteServerError) then
            FileDelete(cFotoQuelle + 'Umbenannt.txt');

        end;
      end;

    end;

  begin
    sBilder := TStringList.create;
    sMeldung := TStringList.create;
    sParameter := TStringList.create;

    cFotoQuelle := cFotoPath + iGeraet + '\';
    MeldungsTAN := '';

    LogFoto('Gerät: ' + iGeraet);

    // Parameter laden
    if FileExists(cFotoQuelle + 'Parameter.ini') then
    begin
      sParameter.LoadFromFile(cFotoQuelle + 'Parameter.ini');
      LogFoto(sParameter);
    end;

    // Parameter setzen
    FotoOffset := strtodoubledef(sParameter.values['KameraOffset'], 0.0) *
      (1.0 / 86400.0);

    // Direktmedlungen von "manuellen" Umbenennungen
    MoveUmbenannt;

    // Dateiliste vom Verzeichnis laden
    // Bild-Liste aufbauen
    dir(cFotoQuelle + '*.jpg', sBilder, false);

    lStat_AnzahlFotos := sBilder.count;
    lStat_AnzahlFotosErkannt := 0;
    if (lStat_AnzahlFotos > 0) then
    begin
      inc(Stat_AnzahlFotos, lStat_AnzahlFotos);
      LogFoto('Bilder-Anzahl: ' + inttostr(lStat_AnzahlFotos));

      sBilderSorter := TStringList.create;

      // Wechsel-Momente vom Server laden
      sWechsel := DataModuleREST.REST
        (iJonDaServer + 'JonDaServer/Statistik/Eingabe.' + iGeraet + '.txt');
      sWechsel.Add(Datum10 + ';' + Uhr8 + ';' + '-1' + ';' + '0');

      for n := 0 to pred(sWechsel.count) do
        sBilderSorter.addObject(
          { } inttostrN(date2long(nextp(sWechsel[n], ';', 0)), 8) + '-' +
          { } nextp(sWechsel[n], ';', 1) + '-' +
          { } 'A' + '-' +
          { } nextp(sWechsel[n], ';', 3),
          { } pointer(n));
      sBilderSorter.sort;
      RemoveDuplicates(sBilderSorter);
      if (sBilderSorter.count > 1) then
        LogFoto('Server-Zeitraum: ' + nextp(sBilderSorter[0], '-', 0) + '...' +
          nextp(sBilderSorter[pred(sBilderSorter.count)], '-', 0));

      ProgressBar1.max := sBilder.count;

      // Foto Belichtungsmoment ermitteln
      iEXIF := TExifData.create;
      for n := 0 to pred(sBilder.count) do
      begin

        ProgressBar1.Position := n;
        LogFoto(sBilder[n]);
        repeat

          // Option 1) Über exif
          if (pos('!', sBilder[n]) <> 1) then
            With iEXIF do
            begin
              if LoadFromGraphic(cFotoQuelle + sBilder[n]) then // Read in file
              begin
                AufnahmeMoment := DateTimeOriginal.Value + FotoOffset;
                sBilderSorter.addObject(inttostrN(DateTime2long(AufnahmeMoment),
                  8) + '-' + SecondsToStr8(DateTime2seconds(AufnahmeMoment)) +
                  '-' + 'E' + '-' + sBilder[n], pointer(n));
                break;
              end;
            end;

          // Option 2) Übers Datei-Datum
          sBilderSorter.addObject(inttostrN(FileDate(cFotoQuelle + sBilder[n]),
            8) + '-' + SecondsToStr8(FileSeconds(cFotoQuelle + sBilder[n])) +
            '-' + 'F' + '-' + sBilder[n], pointer(n));

        until true;

      end;
      iEXIF.free;
      ProgressBar1.Position := 0;
      sBilderSorter.sort;
      sBilderSorter.SaveToFile(DiagnosePath + 'Bild-Merge-' + iGeraet + '.txt');

      // Jetzt den Verknüfungs-Algo
      AutomataState := 0;
      BildIndex := 0;
      repeat
        if (BildIndex >= sBilderSorter.count) then
          break;
        Line := sBilderSorter[BildIndex];

        case AutomataState of
          0:
            begin
              // suche und verarbeite ein "A"
              if (copy(Line, 19, 1) = 'A') then
              begin
                // "A(usbau)"
                WechselDatum := StrToIntDef(copy(Line, 1, 8), 0);
                WechselUhr := StrToSeconds(copy(Line, 10, 8));
                // Details einlesen
                AUFTRAG_R :=
                  StrToIntDef
                  (nextp(sWechsel[Integer(sBilderSorter.objects[BildIndex])],
                  ';', 2), cRID_Null);
                setWechselOptions
                  (sWechsel[Integer(sBilderSorter.objects[BildIndex])]);

                inc(BildIndex);
              end
              else
              begin
                AutomataState := 1;
                AnzahlBilder := 0;
              end;
            end;
          1: // verarbeite ein Bild
            begin
              if (copy(Line, 19, 1) <> 'A') then
              begin
                // "E(xif)" oder "F(ile)"
                BildDatum := StrToIntDef(copy(Line, 1, 8), 0);
                BildUhr := StrToSeconds(copy(Line, 10, 8));
                inc(BildIndex);
                inc(AnzahlBilder);
              end
              else
              begin
                // Nun Schon wieder ein "A"
                if (SecondsDiff(WechselDatum, WechselUhr, BildDatum, BildUhr) <
                  30 * cOneMinuteInSeconds) and (AnzahlBilder >= 1) and
                  (AnzahlBilder <= iMaxAnzahlBilder) then
                begin
                  case AnzahlBilder of
                    1:
                      Move1(BildIndex - 1);
                    2:
                      Move2(BildIndex - 1);
                  else
                    MoveN(BildIndex - 1, AnzahlBilder);
                  end;
                end;
                AutomataState := 0;
              end;
            end;
        end;
      until false;

      sWechsel.free;
      sBilderSorter.free;

    end;

    // Info
    if lStat_AnzahlFotos > 0 then
      LogFoto(
        { } iGeraet + ': ' +
        { } inttostr(lStat_AnzahlFotosErkannt) + ' von ' +
        { } inttostr(lStat_AnzahlFotos) + ' erkannt');

    // Meldung verarbeiten
    if (sMeldung.count > 0) then
    begin
      proceedMeldung;
      openShell(iJonDaServer + 'JonDaServer/Info/' + iGeraet + '.html');
    end;

    sBilder.free;
    sMeldung.free;
    sParameter.free;
  end;

  procedure ExifCheck(iGeraet: string);
  var
    cFotoQuelle: string;
    sBilder: TStringList;
    n: Integer;
    iEXIF: TExifData;
    EXiFMoment: TDateTime;
    DateiMoment: TDateTime;
  begin
    sBilder := TStringList.create;
    cFotoQuelle := cFotoPath + iGeraet + '\';

    LogFoto('Gerät: ' + iGeraet);

    // Dateiliste vom Verzeichnis laden
    // Bild-Liste aufbauen
    dir(cFotoQuelle + '*.jpg', sBilder, false);

    iEXIF := TExifData.create;
    for n := 0 to pred(sBilder.count) do
    begin
      DateiMoment := FileDateTime(cFotoQuelle + sBilder[n]);
      // EXiF Moment
      With iEXIF do
      begin
        if LoadFromGraphic(cFotoQuelle + sBilder[n]) then // Read in file
        begin
          EXiFMoment := DateTimeOriginal;
        end;
      end;

      if (SecondsDiffABS(
        { } DateTime2long(DateiMoment), DateTime2seconds(DateiMoment),
        { } DateTime2long(EXiFMoment), DateTime2seconds(EXiFMoment)) < 5) then
      begin
        LogFoto('EXiF OK: ' + sBilder[n]);
        FileMove(cFotoQuelle + sBilder[n], cFotoPath + sBilder[n]);
        inc(Stat_AnzahlFotosErkannt);
      end;

    end;

    sBilder.free;
  end;

var
  sMonteure: TStringList;
  n: Integer;
begin
  BeginHourGlass;
  ProgressBar1.Position := 0;
  ListBox1.items.clear;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  cFotoPath := e_r_BaustelleFotoPath(BAUSTELLE_R);
  cFotoZiel := IB_Memo5.Lines.values[cE_FotoZiel];
  if (cFotoZiel = '') then
    cFotoZiel := cFotoPath;

  LogFoto('Quelle: ' + cFotoPath);
  LogFoto('Ziel: ' + cFotoZiel);

  Stat_AnzahlFotos := 0;
  Stat_AnzahlFotosErkannt := 0;

  sMonteure := TStringList.create;
  dir(cFotoPath + '*.', sMonteure);

  RemoteServerError := false;
  for n := 0 to pred(sMonteure.count) do
  begin

    if (length(sMonteure[n]) = 3) and (StrToIntDef(sMonteure[n], 0) > 0) then
    begin
      Proceed(sMonteure[n]);
      if RemoteServerError then
        break;
    end;

    if (sMonteure[n] = 'EXIF') then
    begin
      ExifCheck(sMonteure[n]);
      if RemoteServerError then
        break;
    end;

  end;

  if (Stat_AnzahlFotosErkannt < Stat_AnzahlFotos) then
  begin
    n := Stat_AnzahlFotos - Stat_AnzahlFotosErkannt;
    if (n = 1) then
      LogFoto(cERRORText + ' 1 Foto konnte nicht zugeordnet werden')
    else
      LogFoto(cERRORText +
        format(' %d Fotos konnten nicht zugeordnet werden ', [n]));
  end;

  if RemoteServerError then
    LogFoto(cERRORText + ' Abbruch wegen Internet-Störung oder Server-Störung')
  else
    LogFoto('ENDE');

  sMonteure.free;
  EndHourGlass;
  if (Stat_AnzahlFotosErkannt < Stat_AnzahlFotos) then
    ShowMessage(
      { } 'Es sind noch Fotos übrig, die nicht erkannt wurden.' + #13 +
      { } 'Öffnen Sie alle Monteursverzeichnisse um die Fotos zu kontrollieren.'
      + #13 + #13 +
      { } '(Für mehr Infos rund ums Thema: "Zuordnen von Fotos": Drücken Sie Hilfe, dann "Fotos" dann "Anleitung für Monteure")');
end;

procedure TFormBaustelle.SpeedButton6Click(Sender: TObject);
var
  BAUSTELLE_R: Integer;
  sMonteure: TStringList;
  sDir: TStringList;
  n: Integer;
  Stat_AnzahlFotoUnbenannt: Integer;
  Stat_Uploads_Pre: Integer;
  Stat_Uploads_Post: Integer;
  Path: string;
begin

  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;

  Stat_AnzahlFotoUnbenannt := 0;
  Path := e_r_BaustelleFotoPath(BAUSTELLE_R);
  sDir := TStringList.create;
  sMonteure := TStringList.create;

  // Monteure ermitteln
  dir(Path + '*.', sMonteure);
  for n := pred(sMonteure.count) downto 0 do
    if not((length(sMonteure[n]) = 3) and (StrToIntDef(sMonteure[n], 0) > 0))
    then
      sMonteure.Delete(n);

  for n := 0 to pred(sMonteure.count) do
  begin
    dir(Path + sMonteure[n] + '\' + '*.jpg', sDir, false);
    inc(Stat_AnzahlFotoUnbenannt, sDir.count);
  end;

  sMonteure.free;

  repeat

    if (Stat_AnzahlFotoUnbenannt > 0) then
      if not(doit(
        { } format('Es gibt %d unbenannte Bilder.' + #13 +
        { } 'Wenn Sie jetzt hochladen werden diese in einem separaten Bild-Archiv auf die Ablage gestellt.'
        + #13 + 'In der Regel muss dieses Archiv dann manuell nachbearbeitet werden.'
        + #13 + 'Haben Sie schon alle Bilder überprüft?' + #13 +
        'Sind Sie ganz sicher, dass Sie jetzt hochladen wollen',
        [Stat_AnzahlFotoUnbenannt]))) then
        break;

    FotoZip;

    repeat

      dir(e_r_BaustelleUploadPath(BAUSTELLE_R) + '*.zip', sDir, false);
      Stat_Uploads_Pre := sDir.count;

      // Uploads
      try
        if (Stat_Uploads_Pre > 0) then
          FotoUp;
      except
        LogFoto('Upload Probleme ...');
      end;

      dir(e_r_BaustelleUploadPath(BAUSTELLE_R) + '*.zip', sDir, false);
      Stat_Uploads_Post := sDir.count;

      if (Stat_Uploads_Pre > 0) then
      begin
        if (Stat_Uploads_Post = 0) then
        begin
          ShowMessage('Die Übertragung war erfolgreich!')
        end
        else
        begin
          if not(doitTimeOut(
            { } 'Die Übertragung ist fehlgeschlagen.' + #13 +
            { } 'Prüfen Sie die Internetverbindung und die Zugangsdaten.' + #13
            +
            { } 'Nochmal versuchen', 25000)) then
            break;
        end;
      end
      else
      begin
        break;
      end;

    until false;

  until true;

  sDir.free;

end;

procedure TFormBaustelle.SpeedButton7Click(Sender: TObject);
var
  AllCodes: TStringList;
  ThisCodes: TStringList;
  QueryCodes: TStringList;
  NewCodes: TStringList;
  ObsoleteCodes: TStringList;
  TheCode: string;
  n: Integer;
begin
  BeginHourGlass;
  AllCodes := TStringList.create;
  ThisCodes := TStringList.create;
  QueryCodes := TStringList.create;
  NewCodes := TStringList.create;
  ObsoleteCodes := TStringList.create;
  e_r_ProtokollExport(IB_Query1.FieldByName('RID').AsInteger, QueryCodes);
  with IB_Query6 do
  begin
    ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    Open;
    first;
    while not(eof) do
    begin
      if FieldByName('PROTOKOLL').IsNotNull then
      begin
        FieldByName('PROTOKOLL').AssignTo(ThisCodes);
        for n := 0 to pred(ThisCodes.count) do
          if pos('=', ThisCodes[n]) > 0 then
          begin
            TheCode := nextp(ThisCodes[n], '=', 0);
            if AllCodes.indexof(TheCode) = -1 then
              AllCodes.Add(TheCode)
          end;
      end;
      next;
    end;
    close;
  end;

  // fehlende Codes nachtragen
  for n := 0 to pred(AllCodes.count) do
    if QueryCodes.indexof(AllCodes[n]) = -1 then
      NewCodes.Add(AllCodes[n]);

  // überflüssige Codes löschen
  for n := pred(QueryCodes.count) downto 0 do
    if AllCodes.indexof(QueryCodes[n]) = -1 then
      ObsoleteCodes.Add(QueryCodes[n]);

  IB_Query1.edit;
  IB_Query1.FieldByName('PROTOKOLLFELDER').AssignTo(QueryCodes);
  QueryCodes.AddStrings(NewCodes);
  IB_Query1.FieldByName('PROTOKOLLFELDER').assign(QueryCodes);

  if (ObsoleteCodes.count > 0) then
    ShowMessage
      ('Folgende Codes werden nicht verwendet, oder waren bisher immer leer:' +
      #13 + HugeSingleLine(ObsoleteCodes));

  AllCodes.free;
  ThisCodes.free;
  QueryCodes.free;
  NewCodes.free;
  ObsoleteCodes.free;
  EndHourGlass;
end;

procedure TFormBaustelle.SpeedButton8Click(Sender: TObject);
var
  sPath: String;
begin
  sPath := cAuftragErgebnisPath + e_r_BaustellenPfad(IB_Memo5.Lines);
  CheckCreateDir(sPath);
  openShell(sPath);
end;

procedure TFormBaustelle.SpeedButton9Click(Sender: TObject);
begin
  ShowMessage('noch nicht programmiert!');
end;

procedure TFormBaustelle.TabSheet9Show(Sender: TObject);
begin
  ReflectFotoPath;
end;

procedure TFormBaustelle.Button23Click(Sender: TObject);
var
  cAUFTRAEGE: TIB_Cursor;
  p: Tpoint2D;
  RecN: Integer;
  Starttime: dword;
begin
  if IsRunning then
  begin
    BreakIt := true;
  end
  else
  begin
    BeginHourGlass;
    BreakIt := false;
    IsRunning := true;
    RecN := 0;
    Starttime := 0;
    cAUFTRAEGE := DataModuleDatenbank.nCursor;
    with cAUFTRAEGE do
    begin
      sql.Add('SELECT KUNDE_STRASSE,KUNDE_ORT,KUNDE_ORTSTEIL from AUFTRAG WHERE');
      sql.Add(' (BAUSTELLE_R=' + IB_Query1.FieldByName('RID').AsString
        + ') and');
      sql.Add(' (RID = MASTER_R)');
      APiFirst;
      ProgressBar1.max := RecordCount;
      while not(eof) do
      begin
        FormGeoLokalisierung.locate(FieldByName('KUNDE_STRASSE').AsString,
          FieldByName('KUNDE_ORT').AsString, FieldByName('KUNDE_ORTSTEIL')
          .AsString, p);
        inc(RecN);
        ApiNext;
        if frequently(Starttime, 333) then
        begin
          application.processmessages;
          ProgressBar1.Position := RecN;
          if BreakIt then
            break;
        end;
      end;
    end;
    cAUFTRAEGE.free;
    EndHourGlass;
    ProgressBar1.Position := 0;
    IsRunning := false;
  end;
end;

procedure TFormBaustelle.Button24Click(Sender: TObject);
begin
  FormAuftragGeo.show;
end;

procedure TFormBaustelle.Button25Click(Sender: TObject);
var
  qAUFTRAG: TIB_Query;
  Starttime: dword;
  RecN: Integer;
  InternInfo: TStringList;
begin
  BeginHourGlass;
  Starttime := 0;
  RecN := 0;
  InternInfo := TStringList.create;
  qAUFTRAG := DataModuleDatenbank.nQuery;
  with qAUFTRAG do
  begin
    sql.Add('select * from AUFTRAG where');
    if not(CheckBox35.Checked) then
      sql.Add('(BAUSTELLE_R=' + IB_Query1.FieldByName('RID').AsString +
        ') and');
    sql.Add('(STATUS<>6)');
    sql.Add('for update');
    Open;
    ProgressBar1.max := RecordCount;
    first;
    while not(eof) do
    begin
      edit;
      AuftragBeforePost(qAUFTRAG, CheckBox26.Checked);
      post;
      next;
      inc(RecN);
      if frequently(Starttime, 333) or eof then
      begin
        ProgressBar1.Position := RecN;
        application.processmessages;
      end;
    end;
    ProgressBar1.Position := 0;
    qAUFTRAG.free;
    InternInfo.free;
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.SetContext(RID: Integer);
begin
  show;
  IB_Query1.locate('RID', RID, []);
end;

procedure TFormBaustelle.ComboBox5Change(Sender: TObject);
var
  NewRID: Integer;
begin
  NewRID := e_r_BaustelleRIDFromKuerzel(ComboBox5.text);
  if (NewRID > 0) then
    IB_Query1.locate('RID', NewRID, []);
end;

procedure TFormBaustelle.ComboBox6Select(Sender: TObject);
var
  BEARBEITER_R: Integer;
begin
  BEARBEITER_R := FormBearbeiter.FetchRIDFromKurz(ComboBox6.text);
  if (BEARBEITER_R >= cRID_FirstValid) then
    IB_Query1.FieldByName('VERTRETUNG_R').AsInteger := BEARBEITER_R
  else
    IB_Query1.FieldByName('VERTRETUNG_R').clear;
end;

procedure TFormBaustelle.ComboBox7Select(Sender: TObject);
begin
  if ComboBox7.ItemIndex >= 0 then
    IB_Query1.FieldByName('BUNDESLAND_IDX').AsInteger := ComboBox7.ItemIndex;
end;

procedure TFormBaustelle.mShow;
begin
  WindowState := wsnormal;
  show;
end;

procedure TFormBaustelle.Button26Click(Sender: TObject);
var
  cAUFTRAEGE: TIB_Cursor;
  RecN: Integer;
  Starttime: dword;
  BAUSTELLE_R: Integer;
  POSTLEITZAHL_R: Integer;
  AUFTRAG_R: Integer;
  OneInvalid: Boolean;
begin
  BeginHourGlass;

  //
  OneInvalid := false;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;

  cAUFTRAEGE := DataModuleDatenbank.nCursor;
  with cAUFTRAEGE do
  begin
    sql.Add('SELECT A.POSTLEITZAHL_R,A.RID,A.KUNDE_ORTSTEIL,P.ORTSTEIL from AUFTRAG A');
    sql.Add('join POSTLEITZAHLEN P on P.RID=A.POSTLEITZAHL_R');
    sql.Add('WHERE (A.BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.Add(' (A.STATUS <> 6)');
    APiFirst;
    ExportTable(sql, DiagnosePath + 'geo-2.csv');
    ProgressBar1.max := RecordCount;
    RecN := 0;
    while not(eof) do
    begin
      AUFTRAG_R := FieldByName('RID').AsInteger;
      POSTLEITZAHL_R := FieldByName('POSTLEITZAHL_R').AsInteger;

      if FieldByName('ORTSTEIL').IsNull then
      begin
        // alle Referenzen löschen und dadurch Neueintrag durch erneutes "locate" erzwingen!
        e_x_dereference('ABLAGE.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));
        e_x_dereference('AUFTRAG.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));
        e_x_sql('delete from POSTLEITZAHLEN where RID=' +
          inttostr(POSTLEITZAHL_R));
        OneInvalid := true;
      end
      else
      begin
        if FieldByName('KUNDE_ORTSTEIL').IsNull then
          e_x_sql('update AUFTRAG set KUNDE_ORTSTEIL = ''' +
            ensureSQL(FieldByName('ORTSTEIL').AsString) + ''' where RID=' +
            inttostr(AUFTRAG_R));
      end;

      inc(RecN);
      ApiNext;
      if frequently(Starttime, 333) then
      begin
        application.processmessages;
        ProgressBar1.Position := RecN;
        if BreakIt then
          break;
      end;
    end;
  end;
  cAUFTRAEGE.free;
  ProgressBar1.Position := 0;

  EndHourGlass;
  if OneInvalid then
    ShowMessage('Geodaten bilden muss neu ausgeführt werden!');

end;

procedure TFormBaustelle.Button27Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query8.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormBaustelle.Button28Click(Sender: TObject);
begin
  with IB_Query7 do
  begin
    BeginHourGlass;
    ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    if not(Active) then
      Open
    else
      refresh;
    EndHourGlass;
  end;
end;

procedure TFormBaustelle.Button29Click(Sender: TObject);
var
  qAUFTRAG: TIB_Query;
  BAUSTELLE_R: Integer;
  DiesesJahr: string;
  NaechstesJahr: string;
  Date1, Date2: TANFIXDAte;
  m1, m2: Integer;
  Starttime: dword;
  RecN: Integer;
begin
  BeginHourGlass;
  DiesesJahr := JahresZahl;
  NaechstesJahr := inttostrN(strtoint(DiesesJahr) + 1, 4);
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  qAUFTRAG := DataModuleDatenbank.nQuery;
  Starttime := 0;
  RecN := 0;
  with qAUFTRAG do
  begin
    sql.Add('select * from AUFTRAG');
    sql.Add('where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') AND');
    sql.Add(' (STATUS<>6)');
    sql.Add('for update');
    Open;
    ProgressBar1.max := RecordCount;
    first;
    while not(eof) do
    begin
      if FieldByName('SPERRE_VON').IsNotNull and FieldByName('SPERRE_BIS').IsNotNull
      then
      begin
        Date1 := DateTime2long(FieldByName('SPERRE_VON').AsDate);
        Date2 := DateTime2long(FieldByName('SPERRE_BIS').AsDate);
        m1 := strtoint(copy(long2date(Date1), 4, 2));
        m2 := strtoint(copy(long2date(Date2), 4, 2));
        if (m1 > m2) then
        begin
          Date1 := date2long(copy(long2date(Date1), 1, 6) + DiesesJahr);
          Date2 := date2long(copy(long2date(Date2), 1, 6) + NaechstesJahr);
        end
        else
        begin
          Date1 := date2long(copy(long2date(Date1), 1, 6) + DiesesJahr);
          Date2 := date2long(copy(long2date(Date2), 1, 6) + DiesesJahr);
        end;
        edit;
        FieldByName('SPERRE_VON').AsDate := long2datetime(Date1);
        FieldByName('SPERRE_BIS').AsDate := long2datetime(Date2);
        AuftragBeforePost(qAUFTRAG, true);
        post;
      end;
      inc(RecN);
      next;
      if frequently(Starttime, 444) or eof then
      begin
        ProgressBar1.Position := RecN;
        application.processmessages;
      end;
    end;
  end;
  qAUFTRAG.free;
  ProgressBar1.Position := 0;
  EndHourGlass;
end;

procedure TFormBaustelle.Button2Click(Sender: TObject);
var
  BAUSTELLE_R: Integer;
begin
  BeginHourGlass;
  BAUSTELLE_R := IB_Query1.FieldByName('RID').AsInteger;
  e_w_BaustelleKopie(BAUSTELLE_R);
  EndHourGlass;
end;

end.
