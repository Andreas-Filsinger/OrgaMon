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
unit Kalender;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Datenbank, IB_Access, StdCtrls, IB_Controls, ExtCtrls, IB_UpdateBar,
  IB_Components, Grids, IB_Grid, ComCtrls, Buttons;

type
  TFormKalender = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Verwalten: TTabSheet;
    IB_Grid1: TIB_Grid;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Memo1: TIB_Memo;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton8: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormKalender: TFormKalender;

implementation

uses
  globals, anfix32, dbOrgaMon;
{$R *.dfm}

procedure TFormKalender.Button1Click(Sender: TObject);
var
  DatumStart, DatumEnde, DatumIterator: TANFiXDate;
  d, j, m, t: integer;
begin
  DatumStart := date2long(Edit1.text);
  DatumEnde := date2long(Edit2.text);
  if DateOK(DatumStart) and DateOK(DatumEnde) and (DatumStart <= DatumEnde) then
  begin
    BeginHourGlass;
    DatumIterator := DatumStart;
    repeat
      // neuen Datensatz anlegen
      with IB_Query1 do
      begin
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('DATUM').AsDate := long2datetime(DatumIterator);
        FieldByName('ANFIX').AsInteger := DatumIterator;
        FieldByName('KALENDERWOCHE').AsInteger := Kalenderwoche(DatumIterator);
        FieldByName('QUARTAL').AsInteger := Quartal(DatumIterator);

        long2details(DatumIterator, j, m, t);
        d := WeekDay(DatumIterator);
        FieldByName('TAG').AsInteger := t;
        FieldByName('MOND').AsInteger := m;
        FieldByName('JAHR').AsInteger := j;
        FieldByName('TAG_DER_WOCHE').AsInteger := d;
        FieldByName('WOCHENTAG').AsString := WeekDayL(DatumIterator);
        FieldByName('MONAT').AsString := cMonatNamenLang[m];
        if d < 6 then
          FieldByName('WERKTAG').AsString := 'Y'
        else
          FieldByName('WERKTAG').AsString := 'N';

        post;

      end;
      DatumIterator := DatePlus(DatumIterator, 1);

    until (DatumIterator > DatumEnde);

    EndHourGlass;
  end;

end;

procedure TFormKalender.FormActivate(Sender: TObject);
begin
 if IB_Query1.active then
  IB_Query1.refresh
 else
 IB_Query1.open;
end;

procedure TFormKalender.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
  StartDebug('kalender');
end;

procedure TFormKalender.SpeedButton8Click(Sender: TObject);
begin
  IB_Query1.refresh;
end;

end.
