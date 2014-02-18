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
unit AuftragAssist;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Sperre, ExtCtrls, DatePick,
  IB_Components, StdCtrls;

type
  TFormAuftragAssist = class(TForm)
    DatePick1: TDatePick;
    DatePick2: TDatePick;
    DatePick3: TDatePick;
    DatePick4: TDatePick;
    DatePick5: TDatePick;
    DatePick6: TDatePick;
    Label1: TLabel;
    Label2: TLabel;
    Image4: TImage;
    Image1: TImage;
    procedure DatePick1Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure DatePick2Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure DatePick3Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure DatePick4Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure DatePick5Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure DatePick6Strike(Sender: TDatePick; CheckThisDate: TDateTime;
      var CrossColor: TColor);
    procedure Image4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    BaustellenSperreV: TSperre;
    BaustellenSperreN: TSperre;
    Kontext: integer;
    procedure StrikeV(Sender: TDatePick; CheckThisDate: TDateTime; var CrossColor: TColor);
    procedure StrikeN(Sender: TDatePick; CheckThisDate: TDateTime; var CrossColor: TColor);
  public
    { Public-Deklarationen }
    procedure SetContext(RID: integer);
  end;

var
  FormAuftragAssist: TFormAuftragAssist;

implementation

uses
  globals, anfix32, html,
  CareTakerClient, FastGEO, GEOCache,
  Datenbank,
  Funktionen_Auftrag,
   wanfix32;

{$R *.dfm}

procedure TFormAuftragAssist.StrikeV(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  if assigned(BaustellenSperreV) then
    CrossColor := BaustellenSperreV.CheckIt(CheckThisDate,Kontext);
end;

procedure TFormAuftragAssist.StrikeN(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  if assigned(BaustellenSperreN) then
    CrossColor := BaustellenSperreN.CheckIt(CheckThisDate, Kontext);
end;

procedure TFormAuftragAssist.DatePick1Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeV(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.DatePick2Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeV(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.DatePick3Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeV(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.SetContext(RID: integer);
const
  cAbstandMax = 100;
var
  cAUFTRAG: TIB_Cursor;
  cLIST: TIB_Cursor;
  AUSFUEHREN_prev: TAnfixDate;
  AUSFUEHREN: TAnfixDate;
  AUSFUEHREN_next: TAnfixDate;
  BAUSTELLE_R: integer;
  BaustellenSperre: TSperre;
  POI, LOC: TPoint2D;
  Abstand: double;
  DayColor: TColor;
  StateIndex: Integer;

  function GetStateIndexFromBaustelle(BAUSTELLE_R: Integer): Integer;
  var
    cBAUSTELLE: TIB_Cursor;
  begin
    cBAUSTELLE := DataModuleDatenbank.nCursor;
    try
      with cBAUSTELLE do
      begin
        sql.add('select BUNDESLAND_IDX from BAUSTELLE where RID = ' + IntToStr(BAUSTELLE_R));

        ApiFirst;
        if not EOF then
          Result := FieldByName('BUNDESLAND_IDX').AsInteger
        else
          Result := -1;
      end;
    finally
      cBAUSTELLE.Free;
    end;
  end;

begin
  BeginHourGlass;
  try

    if not (assigned(BaustellenSperreV)) then
    begin
      BaustellenSperreV := TSperre.create;
      Feiertage.AddToSperre(cSperreFeiertag,cPrio_FeiertagSperre,BaustellenSperreV);
    end else
    begin
      BaustellenSperreV.Clear;
    end;

    if not (assigned(BaustellenSperreN)) then
    begin
      BaustellenSperreN := TSperre.create;
      Feiertage.AddToSperre(cSperreFeiertag,cPrio_FeiertagSperre,BaustellenSperreN);
    end else
    begin
      BaustellenSperreN.Clear;
    end;

    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      sql.add('select X, Y, VORMITTAGS, AUSFUEHREN, BAUSTELLE_R, MONTEUR1_R from AUFTRAG');
      sql.add('left join POSTLEITZAHLEN on');
      sql.add(' (POSTLEITZAHLEN.RID=AUFTRAG.POSTLEITZAHL_R)');
      sql.add('where');
      sql.add(' (AUFTRAG.RID=' + inttostr(RID) + ')');
      ApiFirst;

      //
      BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
      POI.X := FieldByName('X').AsDouble;
      POI.Y := FieldByName('Y').AsDouble;
      if not (InDe(POI)) then
        raise Exception.create('Auftrag ist nicht geolokalisiert!');

      AUSFUEHREN := datetime2Long(FieldByName('AUSFUEHREN').AsDate);
      if not (DateOK(AUSFUEHREN)) then
        AUSFUEHREN := DateGet;

      AUSFUEHREN_prev := prevMonth(AUSFUEHREN);
      AUSFUEHREN_next := nextMonth(AUSFUEHREN);

      if (FieldByName('VORMITTAGS').AsString = cVormittagsChar) then
        BaustellenSperreV.add(AUSFUEHREN, AUSFUEHREN, true, HTMLColor2TColor($6699FF), cAbstandMax + 1)
      else
        BaustellenSperreN.add(AUSFUEHREN, AUSFUEHREN, true, HTMLColor2TColor($6699FF), cAbstandMax + 1);

      DatePick1.Date := long2datetime(AUSFUEHREN_prev);
      DatePick2.Date := long2datetime(AUSFUEHREN);
      DatePick3.Date := long2datetime(AUSFUEHREN_next);
      DatePick4.Date := long2datetime(AUSFUEHREN_prev);
      DatePick5.Date := long2datetime(AUSFUEHREN);
      DatePick6.Date := long2datetime(AUSFUEHREN_next);

    end;

    StateIndex := GetStateIndexFromBaustelle(BAUSTELLE_R);

    cLIST := DataModuleDatenbank.nCursor;
    with cLIST do
    begin
      sql.add('select distinct X,Y,AUSFUEHREN, VORMITTAGS');
      sql.add('from AUFTRAG');
      sql.add('join POSTLEITZAHLEN on');
      sql.add(' (POSTLEITZAHLEN.RID=AUFTRAG.POSTLEITZAHL_R)');
      sql.add('where');
      sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
      sql.add(' (STATUS IN (' +
        inttostr(cs_Terminiert) + ',' +
        inttostr(cs_Angeschrieben) + ',' +
        inttostr(cs_Monteurinformiert) + ',' +
        inttostr(cs_Restant) +
        '))'
        );
      ApiFirst;
      while not (eof) do
      begin

        LOC.x := FieldByName('X').AsDouble;
        LOC.y := FieldByName('Y').AsDouble;
        if inDE(LOC) then
          Abstand := DistanceEarth(POI, LOC)
        else
          Abstand := cAbstandMax;

        if (FieldByName('VORMITTAGS').AsString = cVormittagsChar) then
          BaustellenSperre := BaustellenSperreV
        else
          BaustellenSperre := BaustellenSperreN;

        if (Abstand < cAbstandMax) and (Abstand >= 0) then
        begin

          repeat

            if (Abstand = 0) then // 0
            begin
              DayColor := HTMLColor2TColor($DFFFA5);
              break;
            end;

            if (Abstand <= 2) then
            begin
              DayColor := HTMLColor2TColor($66CD00);
              break;
            end;

            if (Abstand <= 4) then
            begin
              DayColor := HTMLColor2TColor($FFCC33);
              break;
            end;

            if (Abstand <= 7) then
            begin
              DayColor := HTMLColor2TColor($FF9966);
              break;
            end;

            if (Abstand <= 15) then
            begin
              DayColor := HTMLColor2TColor($FF3300);
              break;
            end;

            if (Abstand <= 25) then
            begin
              DayColor := HTMLColor2TColor($990000);
              break;
            end;
            DayColor := HTMLColor2TColor($000000);

          until true;

          BaustellenSperre.add(
            FieldByName('AUSFUEHREN').AsDate,
            FieldByName('AUSFUEHREN').AsDate,
            true,
            DayColor,
            cAbstandMax - round(Abstand));

        end;
        ApiNext;
      end;
    end;
    cAUFTRAG.free;
    cLIST.free;
  except

  end;
  EndHourGlass;
  show;
end;

procedure TFormAuftragAssist.DatePick4Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeN(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.DatePick5Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeN(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.DatePick6Strike(Sender: TDatePick;
  CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  StrikeN(Sender, CheckThisDate, CrossColor);
end;

procedure TFormAuftragAssist.Image4Click(Sender: TObject);
begin
  openShell(cHelpURL + 'ERP.Assistent');
end;

end.

