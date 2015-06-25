{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Ronny Schupeta
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
unit Auswertung.Generator.MixStatistik.main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, IniFiles,
  Auswertung.Generator.MixStatistik.lnmits, txlib;

type
  TFormAGM_Main = class(TForm)
    MainMenu: TMainMenu;
    Menu_File: TMenuItem;
    Menu_Open: TMenuItem;
    Menu_SaveAs: TMenuItem;
    N1: TMenuItem;
    Menu_GenerateOLAPFiles: TMenuItem;
    N2: TMenuItem;
    Menu_Config: TMenuItem;
    N3: TMenuItem;
    Menu_Exit: TMenuItem;
    ListViewCities: TListView;
    PanelControl: TPanel;
    ButtonAdd: TButton;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    PopupMenuListView: TPopupMenu;
    PopupMenu_Add: TMenuItem;
    PopupMenu_Edit: TMenuItem;
    PopupMenu_Delete: TMenuItem;
    OpenDialogXLS: TOpenDialog;
    SaveDialogXLS: TSaveDialog;
    N4: TMenuItem;
    PopupMenu_SelectAll: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure Menu_SaveAsClick(Sender: TObject);
    procedure Menu_GenerateOLAPFilesClick(Sender: TObject);
    procedure Menu_ConfigClick(Sender: TObject);
    procedure Menu_ExitClick(Sender: TObject);
    procedure Menu_OpenClick(Sender: TObject);
    procedure PopupMenu_SelectAllClick(Sender: TObject);
    procedure ListViewCitiesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewCitiesEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    function IniFName: string;
  public
    { Public-Deklarationen }

    lnmits: TLNMITS;
    LNMITSLoaded: Boolean;
    LNMITSChanged: Boolean;

    LNMITSWorkPath: AnsiString;

    procedure ReadConfig;
    procedure WriteConfig;

    procedure UpdateCaption;
    procedure UpdateCtrls;
    procedure FillListViewCities;
    function CheckDataChanged: Boolean;
    function Open: Boolean;
    function SaveAs: Boolean;
  end;

var
  FormAGM_Main: TFormAGM_Main;

const
  GLOBALCAPTION = 'LN-MITS bearbeiten';

implementation

uses
  globals,
  Auswertung.Generator.MixStatistik.config,
  Auswertung.Generator.MixStatistik.editcity,
  txlib_UI, anfix32;

{$R *.dfm}

procedure TFormAGM_Main.ReadConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(IniFName);
  try
    LNMITSWorkPath := IniFile.ReadString('Settings', 'WorkPath', '');
    lnmits.CityOverviewStart := IniFile.ReadInteger('Settings', 'CityOverviewStart', 10);
    lnmits.CitySheetStart := IniFile.ReadInteger('Settings', 'CitySheetStart', 4);
  finally
    IniFile.Free;
  end;
end;

procedure TFormAGM_Main.WriteConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(IniFName);
  try
    IniFile.WriteString('Settings', 'WorkPath', LNMITSWorkPath);
    IniFile.WriteInteger('Settings', 'CityOverviewStart', lnmits.CityOverviewStart);
    IniFile.WriteInteger('Settings', 'CitySheetStart', lnmits.CitySheetStart);
  finally
    IniFile.Free;
  end;
end;

procedure TFormAGM_Main.UpdateCaption;
begin
  if LNMITSLoaded then
  begin
    if LNMITSChanged then
      Caption := GLOBALCAPTION + ' - Dokument geändert'
    else
      Caption := GLOBALCAPTION + ' - Dokument unverändert';
  end
  else
    Caption := GLOBALCAPTION + ' - Dokument nicht geladen';
end;

procedure TFormAGM_Main.UpdateCtrls;
begin
  Menu_SaveAs.Enabled := LNMITSLoaded;
  Menu_GenerateOLAPFiles.Enabled := LNMITSLoaded;
  ButtonAdd.Enabled := LNMITSLoaded;
  ButtonEdit.Enabled := LNMITSLoaded and (ListViewCities.ItemIndex > 0);
  ButtonDelete.Enabled := LNMITSLoaded and (ListViewCities.SelCount > 0);
  PopupMenu_Add.Enabled := ButtonAdd.Enabled;
  PopupMenu_Edit.Enabled := ButtonEdit.Enabled;
  PopupMenu_Delete.Enabled := ButtonDelete.Enabled;
  PopupMenu_SelectAll.Enabled := LNMITSLoaded and (ListViewCities.Items.Count > 0);
end;

procedure TFormAGM_Main.FillListViewCities;
var
  I, C: Integer;
begin
  ListViewCities.Clear;
  C := lnmits.Cities.Count - 1;
  for I := 0 to C do
    with ListViewCities.Items.Add do
    begin
      Caption := lnmits.Cities.Items[I].City;
      Data := Pointer(lnmits.Cities.Items[I]);
    end;
  ListViewCities.AlphaSort;
  UpdateCtrls;
end;

function TFormAGM_Main.CheckDataChanged: Boolean;
begin
  if LNMITSLoaded then
  begin
    if LNMITSChanged then
    begin
      case MsgBox('Daten haben sich geändert.' + #13#10#13#10 +
        'Sollen diese jetzt gespeichert werden?', MB_ICONQUESTION or MB_YESNOCANCEL) of
        IDYES:
          Result := SaveAs;
        IDNO:
          Result := True;
      else
        Result := False;
      end;
    end
    else
      Result := True;
  end
  else
    Result := True;
end;

function TFormAGM_Main.Open: Boolean;
begin
  Result := False;

  if CheckDataChanged then
  begin
    OpenDialogXLS.FileName := WellFilename(LNMITSWorkPath + '\LN-MITS.Vorlage.xls');
    if OpenDialogXLS.Execute then
    begin
      try
        lnmits.Load(OpenDialogXLS.FileName);

        LNMITSWorkPath := ExtractFilePath(OpenDialogXLS.FileName);

        LNMITSLoaded := True;
        LNMITSChanged := False;

        FillListViewCities;

        UpdateCaption;

        Result := True;
      except
        on E: Exception do
        begin
          lnmits.Clear;
          LNMITSLoaded := False;
          LNMITSChanged := False;

          FillListViewCities;

          UpdateCaption;

          ErrorMsg('Fehler beim Laden der XLS-Datei:' + #13#10#13#10 + E.Message);
        end;
      end;
    end;
  end;
end;

function TFormAGM_Main.SaveAs: Boolean;
var
  Backup: String;
begin
  Result := False;

  SaveDialogXLS.FileName := WellFilename(LNMITSWorkPath + '\LN-MITS.Vorlage.xls');
  if SaveDialogXLS.Execute then
  begin
    try
      if FileExists(SaveDialogXLS.FileName) then
        case MsgBox('Die Datei "' + SaveDialogXLS.FileName + '" ist bereits vorhanden.' +
          #13#10#13#10 + 'Soll von dieser Datei ein Backup erstellt werden?',
          MB_ICONQUESTION or MB_YESNOCANCEL) of
          IDYES:
            begin
              Backup := ExtractFilePath(SaveDialogXLS.FileName) +
                FilenameWithoutExt(SaveDialogXLS.FileName) + '_Backup_' +
                FormatDateTime('yyyymmdd_hhnnss', Now) + ExtractFileExt(SaveDialogXLS.FileName);
              if not FileCopy(SaveDialogXLS.FileName, Backup, False) then
              begin
                ErrorMsg('Fehler: Backup "' + Backup + '" konnte nicht erstellt werden!');
                Exit;
              end;
            end;
          IDCANCEL:
            Exit;
        end;

      LNMITSWorkPath := ExtractFilePath(SaveDialogXLS.FileName);

      lnmits.Save(SaveDialogXLS.FileName);

      LNMITSChanged := False;

      UpdateCaption;
      UpdateCtrls;

      Result := True;

      if lnmits.Cities.CountOlapFiles > 0 then
        Menu_GenerateOLAPFiles.Click;
    except
      on E: Exception do
        ErrorMsg('Fehler beim Speichern der XLS-Datei:' + #13#10#13#10 + E.Message);
    end;
  end;
end;

procedure TFormAGM_Main.FormDestroy(Sender: TObject);
begin
  if assigned(lnmits) then
  begin
    WriteConfig;
    lnmits.Free;
  end;
end;

function TFormAGM_Main.IniFName: string;
begin
  Result := SystemPath + '\Auswertung.Generator.MixStatistik.ini';
end;

procedure TFormAGM_Main.FormActivate(Sender: TObject);
begin
  if not(assigned(lnmits)) then
  begin
    lnmits := TLNMITS.Create;
    LNMITSLoaded := False;
    LNMITSChanged := False;
    ReadConfig;
    MsgBoxTitle(GLOBALCAPTION);
    UpdateCaption;
    UpdateCtrls;
  end;
end;

procedure TFormAGM_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckDataChanged;
end;

procedure TFormAGM_Main.Menu_OpenClick(Sender: TObject);
begin
  Open;
end;

procedure TFormAGM_Main.Menu_SaveAsClick(Sender: TObject);
begin
  SaveAs;
end;

procedure TFormAGM_Main.Menu_GenerateOLAPFilesClick(Sender: TObject);
var
  Path: AnsiString;
  I, C: Integer;
begin
  if LNMITSLoaded then
    if lnmits.Cities.CountOlapFiles > 0 then
    begin
      if MsgBox('Es ist erforderlich ' + IntToStr(lnmits.Cities.CountOlapFiles) +
        ' OLAP-Datei(en) zu erzeugen.' + #13#10#13#10 +
        'Hier ist das Ausgabeverzeichnis der Dateien wichtig, welches normalerweise dem der Datei LN-MITS.Vorlage.xls entspricht.'
        + #13#10#13#10 + 'Klicken Sie auf Ok, um den Vorgang fortzuführen!', MB_ICONINFORMATION or
        MB_OKCANCEL) = IDOK then
      begin
        Path := RequestDir('Verzeichnis für OLAP-Dateien auswählen', LNMITSWorkPath);
        if Path <> '' then
        begin
          try
            C := lnmits.Cities.Count - 1;
            for I := 0 to C do
              if lnmits.Cities.Items[I].HaveToGenerateOlapFile then
                lnmits.Cities.Items[I].GenerateOlapFile(Path);

            InfoMsg('OLAP-Dateien wurden erfolgreich erzeugt.');
          except
            on E: Exception do
              ErrorMsg('Fehler beim Erstellen der OLAP-Dateien:' + #13#10#13#10 + E.Message);
          end;
        end;
      end;
    end
    else
      InfoMsg('Es ist nicht erforderlich OLAP-Dateien zu erzeugen.');
end;

procedure TFormAGM_Main.Menu_ConfigClick(Sender: TObject);
begin
  FormAGM_Config.ShowModal;
end;

procedure TFormAGM_Main.Menu_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAGM_Main.ButtonAddClick(Sender: TObject);
var
  City: TLNMITSCity;
begin
  if LNMITSLoaded then
  begin
    FormAGM_EditCity.Caption := 'Stadt hinzufügen';
    FormAGM_EditCity.LabeledEditCity.Text := '';

    repeat
      FormAGM_EditCity.ShowModal;
      if not FormAGM_EditCity.UserCanceled then
      begin
        try
          City := lnmits.Cities.Add(FormAGM_EditCity.LabeledEditCity.Text);

          with ListViewCities do
          begin
            ClearSelection;
            with Items.Add do
            begin
              Caption := City.City;
              Data := Pointer(City);
              Selected := True;

              ListViewCities.Scroll(0, Position.Y);
            end;
          end;

          LNMITSChanged := True;

          UpdateCtrls;
          UpdateCaption;

          Break;
        except
          on E: Exception do
            ErrorMsg('Fehler: ' + E.Message);
        end;
      end
      else
        Break;
    until False;
  end;
end;

procedure TFormAGM_Main.ButtonEditClick(Sender: TObject);
var
  City: TLNMITSCity;
begin
  if LNMITSLoaded and assigned(ListViewCities.Selected) then
  begin
    City := TLNMITSCity(ListViewCities.Selected.Data);

    FormAGM_EditCity.Caption := 'Stadt bearbieten';
    FormAGM_EditCity.LabeledEditCity.Text := City.City;

    repeat
      FormAGM_EditCity.ShowModal;
      if not FormAGM_EditCity.UserCanceled then
      begin
        try
          City.City := FormAGM_EditCity.LabeledEditCity.Text;

          ListViewCities.Selected.Caption := City.City;

          LNMITSChanged := True;

          UpdateCtrls;
          UpdateCaption;

          Break;
        except
          on E: Exception do
            ErrorMsg('Fehler: ' + E.Message);
        end;
      end
      else
        Break;
    until False;
  end;
end;

procedure TFormAGM_Main.ButtonDeleteClick(Sender: TObject);
var
  CanDelete: Boolean;
  I, C: Integer;
begin
  if LNMITSLoaded then
    if ListViewCities.SelCount > 0 then
    begin
      if ListViewCities.SelCount = 1 then
        CanDelete := MsgBox('Soll die ausgewählte Stadt wirklich gelöscht werden?',
          MB_ICONQUESTION or MB_YESNO) = IDYES
      else
        CanDelete := MsgBox('Sollen die ' + IntToStr(ListViewCities.SelCount) +
          ' ausgewählten Städte wirklich gelöscht werden?', MB_ICONQUESTION or MB_YESNO) = IDYES;

      if CanDelete then
      begin
        try
          C := ListViewCities.Items.Count - 1;
          for I := 0 to C do
            if ListViewCities.Items.Item[I].Selected then
              TLNMITSCity(ListViewCities.Items.Item[I].Data).Delete;
        finally
          ListViewCities.DeleteSelected;

          LNMITSChanged := True;

          UpdateCtrls;
          UpdateCaption;
        end;
      end;
    end;
end;

procedure TFormAGM_Main.PopupMenu_SelectAllClick(Sender: TObject);
begin
  ListViewCities.SelectAll;
end;

procedure TFormAGM_Main.ListViewCitiesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    UpdateCtrls;
end;

procedure TFormAGM_Main.ListViewCitiesEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

end.
