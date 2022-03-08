{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2022  Andreas Filsinger
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
unit main;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, Buttons, Menus,

  // OrgaMon Projekt
  globals,

  // Tools
  anfix, IB_Components, IB_Access, SysHot, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze
  {$ifndef FPC}
  ,JvComponentBase, JvAppStorage, JvAppIniStorage
  {$endif}
  ;

type
  TFormMain = class(TForm)
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button15: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button25: TButton;
    Button9: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Label1: TLabel;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    Button43: TButton;
    Button44: TButton;
    Button46: TButton;
    Button35: TButton;
    Button40: TButton;
    Button48: TButton;
    Button49: TButton;
    Button51: TButton;
    Button53: TButton;
    Button22: TButton;
    Button56: TButton;
    Button57: TButton;
    Button58: TButton;
    Image1: TImage;
    Button39: TButton;
    Button60: TButton;
    Button61: TButton;
    Button62: TButton;
    Button63: TButton;
    Button64: TButton;
    Button65: TButton;
    Button66: TButton;
    Button67: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button16: TButton;
    Button68: TButton;
    Button59: TButton;
    Button69: TButton;
    Button70: TButton;
    Image2: TImage;
    Button72: TButton;
    Button73: TButton;
    Button75: TButton;
    SpeedButton1: TSpeedButton;
    Button76: TButton;
    Button77: TButton;
    Button79: TButton;
    Button80: TButton;
    Button78: TButton;
    Button26: TButton;
    Button81: TButton;
    Button82: TButton;
    Button83: TButton;
    Button50: TButton;
    Timer1: TTimer;
    Button86: TButton;
    CheckBox1: TCheckBox;
    SpeedButton2: TSpeedButton;
    CMS: TLabel;
    Resource: TLabel;
    Button1: TButton;
    Button5: TButton;
    Button45: TButton;
    Button74: TButton;
    Button84: TButton;
    SpeedButton20: TSpeedButton;
    Button14: TButton;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Panel5: TPanel;
    Button24: TButton;
    Button42: TButton;
    IdAntiFreeze1: TIdAntiFreeze;
    Button41: TButton;
    Button55: TButton;
    Panel6: TPanel;
    Panel7: TPanel;
    Button71: TButton;
    Button85: TButton;
    Button88: TButton;
    Button89: TButton;
    {$ifndef FPC}
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    {$endif}
    Button54: TButton;
    Button91: TButton;
    Button47: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure Button46Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure Button48Click(Sender: TObject);
    procedure Button49Click(Sender: TObject);
    procedure Button51Click(Sender: TObject);
    procedure Button53Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button56Click(Sender: TObject);
    procedure Button57Click(Sender: TObject);
    procedure Button58Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button60Click(Sender: TObject);
    procedure Button61Click(Sender: TObject);
    procedure Button63Click(Sender: TObject);
    procedure Button64Click(Sender: TObject);
    procedure Button65Click(Sender: TObject);
    procedure Button66Click(Sender: TObject);
    procedure Button67Click(Sender: TObject);
    procedure Button59Click(Sender: TObject);
    procedure Button69Click(Sender: TObject);
    procedure Button62Click(Sender: TObject);
    procedure Button70Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button72Click(Sender: TObject);
    procedure Button73Click(Sender: TObject);
    procedure Button75Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button76Click(Sender: TObject);
    procedure Button77Click(Sender: TObject);
    procedure Button79Click(Sender: TObject);
    procedure Button80Click(Sender: TObject);
    procedure Button78Click(Sender: TObject);
    procedure Button81Click(Sender: TObject);
    procedure Button82Click(Sender: TObject);
    procedure Button83Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button68Click(Sender: TObject);
    procedure Button50Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button86Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button45Click(Sender: TObject);
    procedure Button74Click(Sender: TObject);
    procedure Button84Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure Button55Click(Sender: TObject);
    procedure Button71Click(Sender: TObject);
    procedure Button85Click(Sender: TObject);
    procedure Button88Click(Sender: TObject);
    procedure Button89Click(Sender: TObject);
    procedure Button91Click(Sender: TObject);
    procedure Button54Click(Sender: TObject);
    procedure Button47Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FirstStarted: boolean;
    sHotKeys: TStringList;
    SysHotKey1: TSysHotKEy;
    procedure HotKey(Sender: TObject; Index: integer);
  public
    { Public-Deklarationen }
    procedure UpdateBenutzer(Sender: TObject);
    procedure IBO_GridResize(Sender: TObject);
    procedure DoUpdate;
    procedure registerHot(EventName: string; ShiftState: THKModifiers; Key: TVirtKey;
      Active: boolean = true);
    procedure hotEvent;
  end;

var
  FormMain: TFormMain;

implementation

uses
  IB_Controls, IB_Grid,
  dbOrgaMon, wanfix, systemd,
  Funktionen_Basis,
  Funktionen_Beleg,
  html, Person, Serie,
  Laender, InternationaleTexte, Datenbank,
  Artikel, SystemPflege, Resource.SiteDownload,
  PersonDoppelte, PersonExport, Belege,
  Lager, ArtikelSortiment, splash, MwSt,
  Einstellungen, ArtikelBild,
  BelegSuche, Datensicherung, PersonSuche,
  CreatorMain, wordindex, AusgangsRechnungen,
  Inventur, Ereignis, Tagesabschluss,
  Versender, VersenderPaketID, BelegRecherche,
  BaseUpdate, ArtikelVerlag, Prorata,
  Aktion, BestellArbeitsplatz, WebShopConnector,
  NatuerlicheResourcen, ArtikelAusgang, PlakatDruck,
  ArtikelPakete, ArtikelRang, ArtikelEingang,
  ArtikelLeistung, Replikation,
  ArtikelKategorie, Mahnung,
  Bearbeiter, OLAP,
  DruckLabel, DruckSpooler, Objektverwaltung,
  KontoAuswertung, LohnTabelle, BudgetKalkulation,
  CareTakerClient, CareServer, RechnungsUebersicht,
  epIMPORT, Zahlungsart, Musiker,
  Arbeitszeit, Budget, Baustelle,
  ArtikelContext, QMain,
  ArtikelEinheit, PersonMailer, AuftragImport,
  AuftragArbeitsplatz, AuftragSuchindex, Tagwache,
  AuftragMobil, AuftragExtern, AuftragErgebnis,
  Buchhalter,
  AutoUp, GeoArbeitsplatz, GeoLokalisierung,
  AuftragGeo, IniFiles,
  GeoPostleitzahlen, ServiceFoto, ServiceApp,
  QTicketArbeitsplatz,
  ZahlungECconnect, Medium,
  Vertrag, Kontext,
  BuchBarKasse,
  Kalender, Auswertung, IB_StringList,
  Audit, Sperre,
  ArtikelKasse, ArtikelAusgabeArt;

{$ifdef FPC}
{$R *.lfm}
{$else}
{$R *.DFM}
{$endif}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  StartDebug('Main');

  caption := cAppName;

  Label1.caption := MachineID;
  top := 2;
  left := 2;
  Image5.left := Image4.left;
  Image5.top := Image4.top;
  Image6.left := Image4.left;
  Image6.top := Image4.top;
  Image7.left := Image4.left;
  Image7.top := Image4.top;
end;

procedure TFormMain.hotEvent;
begin
  WindowState := wsNormal;
  show;
  setfocus;
  SetForegroundWindow(handle);
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  FormPerson.show;
end;

procedure TFormMain.Button6Click(Sender: TObject);
begin
  FormSerie.show;
end;

procedure TFormMain.Button7Click(Sender: TObject);
begin
  FormLaender.show;
end;

procedure TFormMain.Button8Click(Sender: TObject);
begin
  FormInternationaleTexte.show;
end;

procedure TFormMain.Button10Click(Sender: TObject);
begin
  FormReplikation.show;
end;

procedure TFormMain.Button3Click(Sender: TObject);
begin
  FormArtikel.show;
end;

procedure TFormMain.Button11Click(Sender: TObject);
begin
  FormSystemPflege.show;
end;

procedure TFormMain.Button12Click(Sender: TObject);
begin
  FormPersonDoppelte.show;
end;

procedure TFormMain.Button13Click(Sender: TObject);
begin
  FormPersonExport.show;
end;

procedure TFormMain.Button14Click(Sender: TObject);
begin
  FormBuchBarKasse.setContext;
end;

procedure TFormMain.Button15Click(Sender: TObject);
begin
  FormLager.show;
end;

procedure TFormMain.Button17Click(Sender: TObject);
begin
  FormArtikelSortiment.show;
end;

procedure TFormMain.Button4Click(Sender: TObject);
begin
  FormBelegSuche.show;
end;

procedure TFormMain.FormActivate(Sender: TObject);
var
  sSystemSettings: TStringList;
  n, m: integer;
  _name, _settings: string;

  LastRev: integer;
  ThisRev: integer;
  r: integer;
  LastRun: TIniFile;

  procedure SetServerStatus(sParam: string; const Panel: TPanel; var pDisabled: boolean);
  begin
    if IsParam(sParam) then
    begin
      if assigned(Panel) then
        Panel.color := clred;
      pDisabled := true;
    end
    else
    begin
      if assigned(Panel) then
        Panel.color := clSilver;
      pDisabled := false;
    end;
  end;

begin
  if not(FirstStarted) then
  begin

    // verhindern des mehrmaligen Starts
    FirstStarted := true;

    // Datenbank verbinden
    try

      with DataModuleDatenbank.IB_Connection1 do
      begin
        UserName := iDataBaseUser;
        Password := deCrypt_Hex(iDataBasePassword);

        // entschlüsseltes Passwort anzeigen
        if IsParam('-sp') then
          ShowMessage(Password);

        // Eventuelle Masken im Datenbankname entfernen
        iDataBaseName := e_r_NameFromMask(iDataBaseName);

        if (iDataBaseName = '') then
        begin
          ShowMessage('Kein Datenbankname angegeben!');
          halt;
        end;

        Connect;
        MachineIDChanged;
      end;

    except
      on E: Exception do
      begin
        SplashClose;
        ShowMessage('Keine Verbindung möglich mit' + #13 +
          DataModuleDatenbank.IB_Connection1.DataBaseName + #13 + E.Message);
        FormBaseUpdate.CloseOrgaMon;
        exit;
      end;
    end;
    FormDatensicherung.IBC := DataModuleDatenbank.IB_Connection1;

    //
    SplashClose;
    StartDebug('close-splash');
    BeginHourglass;

    application.processmessages;
    SetForegroundWindow(handle);
    Button37.setfocus;

    // ggf. ein Update durchführen
    DoUpdate;
    StartDebug('after-update');

    if iForceAppDown then
     exit;

    // Systemparameter ermitteln
    sSystemSettings := e_r_LadeParameter;

    if isBeta then
      iFormColor := $A0A0CC;

    // Lokale Release-Updates durchführen (jeder Client!)
    ThisRev := RevAsInteger(globals.Version);

    // die zuletzt benutze Version ermitteln
    try
      CheckCreateDir(EigeneOrgaMonDateienPfad);
      LastRun := TIniFile.Create(EigeneOrgaMonDateienPfad + 'LastRun.ini');
      with LastRun do
      begin
        LastRev := StrToIntDef(ReadString(cGroup_Id_Default, 'Version', ''), 7680);
        if (LastRev <> ThisRev) then
          WriteString(cGroup_Id_Default, 'Version', Inttostr(ThisRev));
      end;
      LastRun.Free;
    except
      LastRev := 7680;
    end;

    //
    if DebugMode then
      AppendStringsTofile(sBootSequence, EigeneOrgaMonDateienPfad + iMandant + '-Boot.log');

    // Arbeiten durchführen, die bei Releaseänderungen gemacht werden müssen
    for r := succ(LastRev) to ThisRev do
      MigrateFrom(r);

    for n := 0 to pred(application.ComponentCount) do
    begin
      if application.Components[n] is TForm then
        with application.Components[n] as TForm do
        begin

          // Farbe des Forms
          if (iFormColor <> clBtnFace) then
          begin
            color := iFormColor;
            for m := 0 to pred(ComponentCount) do
              if Components[m] is TPanel then
                with Components[m] as TPanel do
                  if ParentColor then
                    color := iFormColor;
          end;

          // DPI-Aware
            for m := 0 to pred(ComponentCount) do
             if Components[m] is TIB_Grid then
                with Components[m] as TIB_Grid do
                 OnResize := IBO_GridResize;


          // Einstellungen für Queries
          _settings := sSystemSettings.Values[name];
          if (_settings <> '') then
          begin
            _name := nextp(_settings, '=');
            for m := 0 to pred(ComponentCount) do
            begin
              if Components[m] is TIB_Query then
                with Components[m] as TIB_Query do
                begin
                  if (name = _name) then
                  begin
                    while (_settings <> '') do
                      Fieldsvisible.add(nextp(_settings, ',') + '=FALSE');
                    break;
                  end;
                end;
            end;
          end;
        end;
    end;
    StartDebug('after-colour-forms');

    if IsParam('-ds') then
    begin
      Panel1.color := clred;
      Panel2.color := clred;
      Panel3.color := clred;
      Panel4.color := clred;
      Panel5.color := clred;
      Panel6.color := clred;
      Panel7.color := clred;
      pDisableAll := true;
      Button91.Enabled := true;
      Button54.Enabled := true;
    end else
    begin
      SetServerStatus('-dm', Panel1, pDisableMailer);
      SetServerStatus('-dx', Panel2, pDisableXMLRPC);
      SetServerStatus('-dt', Panel3, pDisableTagesabschluss);
      SetServerStatus('-dw', Panel4, pDisableTagwache);
      SetServerStatus('-dh', Panel5, pDisableHotkeys);
      SetServerStatus('-dd', Panel6, pDisableDrucker);
      SetServerStatus('-dk', Panel7, pDisableKasse);
    end;

    // Hot-Keys
    if not(pDisableHotkeys) then
    begin
      if pos(AnsiUpperCase(noblank(Computername)) + ',',
        AnsiUpperCase(noblank(iArtikelAusgang_ScannerHost) + ',')) > 0 then
        FormArtikelAusgang.doActivate(true);

      if pos(AnsiUpperCase(noblank(Computername)) + ',',
        AnsiUpperCase(noblank(iArtikelEingang_ScannerHost) + ',')) > 0 then
        FormArtikelEingang.doActivate(true);

      if pos(AnsiUpperCase(noblank(Computername)) + ',',
        AnsiUpperCase(noblank(iMagnetoHost) + ',')) > 0 then
      begin
        FormZahlungECconnect.doActivate(true);
        FormBuchBarKasse.Swap;
      end;

      registerHot('Menü', [hkAlt], vkf10, true);
    end;
    sSystemSettings.Free;
    StartDebug('after-hotkeys');

    // Benutzer-Sachen
    FormBearbeiter.OnChange := UpdateBenutzer;
    FormBearbeiter.Start;

    if not(pDisableAll) then
    begin
      // Erzeuge Caches beim Start

      // Artikel
      application.processmessages;
      FormArtikel.BuildCache;
      Button3.enabled := true;
      StartDebug('after-cache-artikel');

      // Belege
      application.processmessages;
      FormBelege.BuildCache;
      Button4.enabled := true;
      StartDebug('after-cache-belege');

      // Person
      application.processmessages;
      FormPersonSuche.BuildCache;
      FormPerson.BuildCache;
      Button2.enabled := true;
      StartDebug('after-cache-person');

      // CareTaker Sachen
      application.processmessages;

    end else
    begin
      Button2.enabled := true;
      Button3.enabled := true;
      Button4.enabled := true;
    end;

    // Haupteinstiege, die gesperrt werden können
    application.processmessages;
    Button68.enabled := bBilligung('Zahlung');

    AllSystemsRunning := true; { eigentlich erst nach dem Update! }

    Button56.enabled := (iSchnelleRechnung_PERSON_R >= cRID_FirstValid);

    JvAppIniFileStorage1.FileName := AnwenderPath + 'Formularpositionen.ini';

    // Scanner (ArtikelAusgang)
    Button49.enabled := true;

    EndHourGlass;

    if bErlaubnis('Kasse Autostart') then
    begin
      FormArtikelKasse.prepare;
      FormArtikelKasse.show;
    end;

    StartDebug('all-systems-running');

  end;

end;

procedure TFormMain.Button19Click(Sender: TObject);
begin
  FormMwSt.show;
end;

procedure TFormMain.Button20Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'TerminPlaner.exe');
end;

procedure TFormMain.Button21Click(Sender: TObject);
begin
  FormEinstellungen.show;
end;

procedure TFormMain.Button25Click(Sender: TObject);
begin
  FormDatensicherung.show;
end;

procedure TFormMain.Button9Click(Sender: TObject);
begin
  FormPersonSuche.show;
end;

procedure TFormMain.Button18Click(Sender: TObject);
begin
  FormCreatorMain.show;
end;

procedure TFormMain.Button27Click(Sender: TObject);
begin
  FormRechnungsUebersicht.show;
end;

procedure TFormMain.Button28Click(Sender: TObject);
begin
  FormAusgangsRechnungen.show;
end;

procedure TFormMain.Button29Click(Sender: TObject);
begin
  FormInventur.show;
end;

procedure TFormMain.Button30Click(Sender: TObject);
begin
  FormEreignis.show;
end;

procedure TFormMain.Button31Click(Sender: TObject);
begin
  FormTagesAbschluss.show;
end;

procedure TFormMain.Button32Click(Sender: TObject);
begin
  FormVersender.show;
end;

procedure TFormMain.Button33Click(Sender: TObject);
begin
  FormVersenderPaketID.show;
end;

procedure TFormMain.Button34Click(Sender: TObject);
begin
  FormBelegRecherche.show;
end;

procedure TFormMain.Button36Click(Sender: TObject);
begin
  FormBaseUpdate.show;
end;

procedure TFormMain.Button37Click(Sender: TObject);
begin
  openShell(myApplicationPath + cApplicationName + '_Info.html');
end;

procedure TFormMain.Button38Click(Sender: TObject);
begin
  FormArtikelVerlag.show;
end;

procedure TFormMain.Button44Click(Sender: TObject);
begin
  FormArtikelAusgabeArt.show;
end;

procedure TFormMain.Button45Click(Sender: TObject);
begin
  FormMedium.show;
end;

procedure TFormMain.Button43Click(Sender: TObject);
begin
  FormProrata.show;
end;

procedure TFormMain.Button46Click(Sender: TObject);
begin
  FormBestellArbeitsplatz.show;
end;

procedure TFormMain.Button47Click(Sender: TObject);
begin
 FormArtikelEingang.Show;
end;

procedure TFormMain.Button35Click(Sender: TObject);
begin
  FormWebShopConnector.show;
end;

procedure TFormMain.Button40Click(Sender: TObject);
begin
  FormAktion.show;
end;

procedure TFormMain.Button41Click(Sender: TObject);
begin
  FormKalender.show;
end;

procedure TFormMain.Button48Click(Sender: TObject);
begin
  FormNatuerlicheResourcen.show;
end;

procedure TFormMain.Button49Click(Sender: TObject);
begin
  FormArtikelAusgang.show;
end;

procedure TFormMain.Button51Click(Sender: TObject);
begin
  FormArtikelPakete.show;
end;

procedure TFormMain.Button53Click(Sender: TObject);
begin
  FormArtikelRang.show;
end;

procedure TFormMain.Button54Click(Sender: TObject);
begin
  FormServiceFoto.showModal;
end;

procedure TFormMain.Button91Click(Sender: TObject);
begin
  FormServiceApp.showModal;
end;

procedure TFormMain.Button55Click(Sender: TObject);
begin
  FormAuswertung.show;
end;

procedure TFormMain.Button22Click(Sender: TObject);
begin
  FormArtikelLeistung.show;
end;

procedure TFormMain.Button56Click(Sender: TObject);
begin
  FormBelege.setContext(iSchnelleRechnung_PERSON_R);
  FormBelege.Neu;
end;

procedure TFormMain.Button57Click(Sender: TObject);
begin
  FormArtikelKategorie.show;
end;

procedure TFormMain.Button58Click(Sender: TObject);
begin
  FormMahnung.show;
end;

procedure TFormMain.Image1DblClick(Sender: TObject);
begin
  FormBearbeiter.ShowPrivatProperties(FormBearbeiter.sBEARBEITER);
end;

procedure TFormMain.UpdateBenutzer(Sender: TObject);
begin
  sBEARBEITER := FormBearbeiter.sBEARBEITER;
  sBearbeiterKurz := FormBearbeiter.sBearbeiterKurz;
  Image1.Picture.Bitmap.Assign(FormBearbeiter.FetchBILDFromRID(sBEARBEITER));
  Label1.caption := MachineID;
  FormQMain.UpdateBenutzer;
  Timer1.enabled := FormBearbeiter.bBilligung('FehlerAbzeichnen');
end;

procedure TFormMain.Button39Click(Sender: TObject);
begin
  FormOLAP.show;
end;

procedure TFormMain.Button60Click(Sender: TObject);
begin
  FormDruckLabel.show;
end;

procedure TFormMain.Button61Click(Sender: TObject);
begin
  FormDruckSpooler.show;
end;

procedure TFormMain.Button63Click(Sender: TObject);
begin
  FormObjektverwaltung.show;
end;

procedure TFormMain.Button64Click(Sender: TObject);
begin
  FormKontoAuswertung.show;
end;

procedure TFormMain.Button65Click(Sender: TObject);
begin
  FormLohntabelle.show;
end;

procedure TFormMain.Button66Click(Sender: TObject);
begin
  FormBudget.show;
end;

procedure TFormMain.Button67Click(Sender: TObject);
begin
  FormCareServer.show;
end;

procedure TFormMain.Button59Click(Sender: TObject);
begin
  FormZahlungsart.show;
end;

procedure TFormMain.Button69Click(Sender: TObject);
begin
  FormMusiker.show;
end;

procedure TFormMain.Button62Click(Sender: TObject);
begin
  FormBaustelle.mShow;
end;

procedure TFormMain.Button70Click(Sender: TObject);
begin
  FormArbeitszeit.show;
end;

procedure TFormMain.Button71Click(Sender: TObject);
begin
  FormAudit.show;
end;

procedure TFormMain.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL);
end;

procedure TFormMain.Button72Click(Sender: TObject);
begin
  FormArtikelContext.show;
end;

procedure TFormMain.Button73Click(Sender: TObject);
begin
  FormQMain.show;
end;

procedure TFormMain.Button74Click(Sender: TObject);
begin
  FormPlakatDruck.show;
end;

procedure TFormMain.Button75Click(Sender: TObject);
begin
  FormBearbeiter.show;
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
begin
  openShell(AnwenderPath);
end;

procedure TFormMain.SpeedButton20Click(Sender: TObject);
begin
  FormKontext.browse;
end;

procedure TFormMain.SpeedButton2Click(Sender: TObject);
begin
  openShell(DiagnosePath);
end;

procedure TFormMain.HotKey(Sender: TObject; Index: integer);
begin
  if assigned(sHotKeys) then
  begin
    repeat
      if (sHotKeys[Index] = 'Scanner') then
        FormArtikelAusgang.hotEvent;
      if (sHotKeys[Index] = 'EC-Karte') then
        FormZahlungECconnect.hotEvent;
      if (sHotKeys[Index] = 'Menü') then
        FormMain.hotEvent;
    until true;
  end;
end;

procedure TFormMain.Button76Click(Sender: TObject);
begin
  FormArtikelEinheit.show;
end;

procedure TFormMain.Button77Click(Sender: TObject);
begin
  FormPersonMailer.show;
end;

procedure TFormMain.Button79Click(Sender: TObject);
begin
  FormAuftragImport.mShow;
end;

procedure TFormMain.Button80Click(Sender: TObject);
begin
  FormAuftragArbeitsplatz.mShow;
end;

procedure TFormMain.Button78Click(Sender: TObject);
begin
  if Doit('Den Suchindex neu erstellen') then
    FormAuftragSuchindex.reCreateTheIndex;
end;

procedure TFormMain.Button81Click(Sender: TObject);
begin
  FormAuftragMobil.show;
end;

procedure TFormMain.Button82Click(Sender: TObject);
begin
  FormAuftragErgebnis.show;
end;

procedure TFormMain.Button83Click(Sender: TObject);
begin
  FormAuftragExtern.show;
end;

procedure TFormMain.Button84Click(Sender: TObject);
begin
  FormVertrag.setContext(cRID_NULL);
end;

procedure TFormMain.Button85Click(Sender: TObject);
begin
  FormArtikelBild.show;
end;

procedure TFormMain.Button26Click(Sender: TObject);
begin
  FormTagwache.show;
end;

procedure TFormMain.Button42Click(Sender: TObject);
begin
  FormGeoArbeitsplatz.mShow;
end;

procedure TFormMain.Button68Click(Sender: TObject);
begin
  FormBuchhalter.show;
end;

procedure TFormMain.Button50Click(Sender: TObject);
begin
  FormAutoUp.show;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  if not(NoTimer) and AllSystemsRunning then
  begin
   if (ReportedErrorCount>0) then
   begin
    NoTimer := true;
    ShowMessageTimeOut(
      {} 'Es gab '+IntToStr(ReportedErrorCount)+' Fehler.'+#13#10+
      {} 'Im Diagnosverzeichnis finden sich'+#13#10+
      {} '*-' + e_r_Kontext + '-ERROR'+
      {} cLogExtension+'-Dateien mit'+#13#10+
      {} 'mehr Information.',
      {} 8000,
      {} true);
    ReportedErrorCount := 0;
    NoTimer := false;
   end;
  end;
end;

procedure TFormMain.Button86Click(Sender: TObject);
begin
  FormAuftragGeo.mShow;
end;

procedure TFormMain.CheckBox1Click(Sender: TObject);
begin
  DebugMode := CheckBox1.checked;
  if DebugMode then
  begin
    Sperre.TestMode := true;
  end else
  begin
    if assigned(Sperre.sDiagnose) then
    begin
      Sperre.sDiagnose.SaveToFile(DiagnosePath + 'Sperre.txt');
      Sperre.sDiagnose.clear;
    end;
    Sperre.TestMode := false;
  end;
end;

procedure TFormMain.Button88Click(Sender: TObject);
begin
  FormSiteDownload.show;
end;

procedure TFormMain.Button89Click(Sender: TObject);
begin
  FormArtikelKasse.prepare;
  FormArtikelKasse.show;
end;

procedure TFormMain.DoUpdate;
begin
  // Alle Bilder aus!
  Image4.visible := false;
  Image5.visible := false;
  Image6.visible := false;
  Image7.visible := false;

  case FormBaseUpdate.DoUpdateIfNeeded(DataModuleDatenbank.IB_Connection1) of
    cUpdate_Aktuell:
      Image7.visible := true;
    cUpdate_Laufend:
      Image5.visible := true;
    cUpdate_Verfuegbar:
      Image6.visible := true;
    cUpdate_Ungeprueft:
      ;
  else
    Image4.visible := true;
  end;
end;

procedure TFormMain.registerHot(EventName: string; ShiftState: THKModifiers; Key: TVirtKey;
  Active: boolean);
var
  iHotIndex: integer;
begin

  if not(assigned(sHotKeys)) then
  begin
    SysHotKey1 := TSysHotKEy.Create(self);
    SysHotKey1.OnHotKey := HotKey;
    sHotKeys := TStringList.Create;
  end;

  iHotIndex := sHotKeys.IndexOf(EventName);
  if (iHotIndex = -1) then
  begin
    if Active then
    begin
      sHotKeys.add(EventName);
      SysHotKey1.AddHotKey(Key, ShiftState);
    end;
  end
  else
  begin
    if not(Active) then
    begin
      sHotKeys.Delete(iHotIndex);
      SysHotKey1.Delete(iHotIndex);
    end;
  end;

  SysHotKey1.Active := (sHotKeys.Count > 0);
end;

procedure TFormMain.Button16Click(Sender: TObject);
begin
  FormEPimport.show;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  FormQTicketArbeitsplatz.show;
end;

procedure TFormMain.Button5Click(Sender: TObject);
begin
  openShell(MDEPath + 'Index.html');
end;

procedure TFormMain.Button24Click(Sender: TObject);
begin
  FormBelege.mShow;
end;

procedure TFormMain.IBO_GridResize(Sender: TObject);
begin
 with Sender as TIB_Grid do
  DefaultRowHeight := DPIx(19);
end;

end.
