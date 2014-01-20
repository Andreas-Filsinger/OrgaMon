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
unit BelegRecherche;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, IB_Components, ExtCtrls;

type
  TFormBelegRecherche = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SearchFail;
  public
    { Public-Deklarationen }
    DontSetContext: boolean;
    BELEG_R: integer;
  end;

var
  FormBelegRecherche: TFormBelegRecherche;

implementation

uses
  IBExportTable, Belege, anfix32,
  BBelege, Datenbank,
  Funktionen.Basis,
  Funktionen.Beleg,
  wanfix32;
{$R *.DFM}

procedure TFormBelegRecherche.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LeaveForm: boolean;
  isRechnungsNummer: boolean;
  isBelegNummer: boolean;
begin
  LeaveForm := false;
  case Key of
    vk_escape:
      begin
        Key := 0;
        BELEG_R := cRID_null;
        LeaveForm := true;
      end;
    vk_return:
      begin
        Key := 0;
        BELEG_R := strtol(Edit1.Text);
        if RadioButton1.checked then
        begin
          // Es könnte eine Rechnungsnummer oder eine Belegnummer sein!
          isBelegNummer := e_r_sql
            ('select count(RID) from BELEG where RID=' + inttostr(BELEG_R))
            > 0;
          isRechnungsNummer := e_r_sql(
            'select count(BELEG_R) from VERSAND where RECHNUNG=' + inttostr
              (BELEG_R)) > 0;

          if isBelegNummer and isRechnungsNummer then
          begin
            isBelegNummer := doit(
              'Diese Nummer gibt es als Belegnummer UND Rechnungsnummer!' +
                #13 + 'Soll die Belegnummer angewendet werden');
            isRechnungsNummer := not(isBelegNummer);
          end;

          if isBelegNummer or isRechnungsNummer then
          begin
            if isRechnungsNummer then
              BELEG_R := e_r_sql(
                'select BELEG_R from VERSAND where RECHNUNG=' + inttostr
                  (BELEG_R));
            LeaveForm := true;
            if not(DontSetContext) then
              FormBelege.SetContext(0, BELEG_R);
          end
          else
          begin
            SearchFail;
          end;
        end
        else
        begin
          if e_r_sql(
            'select count(RID) from BBELEG where RID=' + inttostr(BELEG_R))
            = 1 then
          begin
            LeaveForm := true;
            if not(DontSetContext) then
              FormBBelege.SetContext(0, BELEG_R);
          end
          else
          begin
            SearchFail;
          end;
        end;
      end;
  end;
  if LeaveForm then
  begin
    LeaveForm := false;
    self.close;
  end;
end;

procedure TFormBelegRecherche.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#13, #27] then
    Key := #0;
end;

procedure TFormBelegRecherche.FormActivate(Sender: TObject);
begin
  BELEG_R := cRID_null;
end;

procedure TFormBelegRecherche.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DontSetContext := false;
end;

procedure TFormBelegRecherche.RadioButton1Click(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TFormBelegRecherche.RadioButton2Click(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TFormBelegRecherche.SearchFail;
begin
  beep;
  BELEG_R := 0;
  Label1.caption := 'nicht gefunden!';
  delay(800);
  Label1.caption := '#';
end;

end.
