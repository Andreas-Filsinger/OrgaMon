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
unit AuftragSuchindex;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls, IB_Components, globals,
  IBExportTable;

type
  TFormAuftragSuchindex = class(TForm)
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure doWork(BAUSTELLE_R: integer = cRID_Null);
  public
    { Public-Deklarationen }
    procedure ReCreateTheIndex(BAUSTELLE_R: integer = cRID_Null);
  end;

var
  FormAuftragSuchindex: TFormAuftragSuchindex;

implementation

uses
  anfix32, WordIndex,
  gplists,
  Funktionen.Basis,
  Funktionen.Auftrag,
  CareTakerClient, Datenbank;
{$R *.DFM}

procedure TFormAuftragSuchindex.Button1Click(Sender: TObject);
begin
  doWork;
end;

procedure TFormAuftragSuchindex.doWork(BAUSTELLE_R: integer);
var
  cAUFTRAEGE: TIB_Cursor;
  lBAUSTELLE: TgpIntegerList;
  _hnr_part: string;

  function _str_part(s: string): string;
  var
    _FirstNummernPos: integer;
    n: integer;
  begin
    _FirstNummernPos := 0;
    for n := 1 to length(s) do
      if s[n] in ['0' .. '9'] then
      begin
        _FirstNummernPos := n;
        break;
      end;

    if _FirstNummernPos > 0 then
    begin
      result := cutblank(copy(s, 1, pred(_FirstNummernPos)));
      _hnr_part := 'h' + noblank(copy(s, _FirstNummernPos, MaxInt));
    end
    else
    begin
      result := s;
      _hnr_part := '';
    end;

  end;

  procedure SaveAs(FName: string);
  var
    TheSearch: TWordIndex;
    RecN: integer;
    StartTime: dword;
    AddStr: string;
    _monteur: string;
    ZaehlerNummerS: string;
    ReglerNummerS: string;
  begin
    BeginHourGlass;
    RecN := 0;
    StartTime := 0;
    TheSearch := TWordIndex.create(nil, 1);
    with cAUFTRAEGE do
    begin
      Open;
      //
      APIfirst;
      ProgressBar1.Max := RecordCount;
      while not(eof) do
      begin
        // Monteur
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _monteur := e_r_MonteurKuerzel
            (FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _monteur := _monteur + ' ' + e_r_MonteurKuerzel
              (FieldByName('MONTEUR2_R').AsInteger);
        end
        else
        begin
          _monteur := '';
        end;

        // Zaehlernummer
        ZaehlerNummerS := noblank(FieldByName('ZAEHLER_NUMMER').AsString);
        while (pos('0', ZaehlerNummerS) = 1) do
          system.delete(ZaehlerNummerS, 1, 1);
        ersetze('-', '', ZaehlerNummerS);

        // Reglernummer
        ReglerNummerS := noblank(FieldByName('REGLER_NR').AsString);
        while (pos('0', ReglerNummerS) = 1) do
          system.delete(ReglerNummerS, 1, 1);
        ersetze('-', '', ReglerNummerS);

        // aufaddieren ...
        AddStr := ZaehlerNummerS + ' ' + ReglerNummerS + ' ' + _monteur + ' ' +
          FieldByName('KUNDE_NUMMER').AsString + ' ' + FieldByName
          ('BRIEF_NAME1').AsString + ' ' + FieldByName('BRIEF_NAME2')
          .AsString + ' ' + FieldByName('BRIEF_STRASSE')
          .AsString + ' ' + FieldByName('BRIEF_ORT')
          .AsString + ' ' + FieldByName('KUNDE_NAME1')
          .AsString + ' ' + FieldByName('KUNDE_NAME2')
          .AsString + ' ' + _str_part(FieldByName('KUNDE_STRASSE').AsString)
          + ' ' + _hnr_part + ' ' + FieldByName('KUNDE_ORT')
          .AsString + ' ' + e_r_BaustelleKuerzel
          (FieldByName('BAUSTELLE_R').AsInteger) + inttostrN
          (FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length)
          + ' ' + inttostrN(FieldByName('NUMMER').AsInteger,
          cAuftragsNummer_Length);

        TheSearch.AddWords(AddStr, TObject(FieldByName('RID').AsInteger));

        inc(RecN);
        APInext;

        if frequently(StartTime, 400) or eof then
        begin
          ProgressBar1.position := RecN;
          application.processmessages;
        end;

      end;
      close;
    end;
    //
    DataModuleDatenbank.BeginFreeze;
    TheSearch.JoinDuplicates(false);
    TheSearch.SaveToFile(FName);
    DataModuleDatenbank.EndFreeze;
    TheSearch.free;
    EndHourGlass;
  end;

var
  n: integer;
  AnzahlAufgaben: integer;
  ErledigteAufgaben: integer;

begin
  try

    if (BAUSTELLE_R >= cRID_FirstValid) then
    begin
      lBAUSTELLE := TgpIntegerList.create;
      lBAUSTELLE.add(BAUSTELLE_R);
      AnzahlAufgaben := 1;
    end else
    begin
      lBAUSTELLE := e_r_sqlm(
        'select RID from BAUSTELLE where SUCHINDEX_AUS=''' + cC_True + '''');
      AnzahlAufgaben := lBAUSTELLE.count + 1;
    end;

    ErledigteAufgaben := 0;

    Label1.caption := '1/' + inttostr(AnzahlAufgaben);
    application.processmessages;

    //
    cAUFTRAEGE := DataModuleDatenbank.nCursor;
    with cAUFTRAEGE do
    begin

      sql.add('SELECT');
      sql.add(' RID,');
      sql.add(' MONTEUR1_R,');
      sql.add(' MONTEUR2_R,');
      sql.add(' KUNDE_NUMMER,');
      sql.add(' ZAEHLER_NUMMER,');
      sql.add(' REGLER_NR,');
      sql.add(' BRIEF_NAME1,');
      sql.add(' BRIEF_NAME2,');
      sql.add(' BRIEF_STRASSE,');
      sql.add(' BRIEF_ORT,');
      sql.add(' KUNDE_NAME1,');
      sql.add(' KUNDE_NAME2,');
      sql.add(' KUNDE_STRASSE,');
      sql.add(' KUNDE_ORT,');
      sql.add(' BAUSTELLE_R,');
      sql.add(' NUMMER');
      sql.add('FROM');
      sql.add(' AUFTRAG');
      sql.add('WHERE');
      sql.add(' (STATUS<>6)');

      if (BAUSTELLE_R < cRID_FirstValid) then
      begin
        if (lBAUSTELLE.count > 0) then
          sql.add(' and (BAUSTELLE_R not in ' + ListasSQL(lBAUSTELLE) + ')');
        SaveAs(SearchDir + cAuftragsIndexFName);
        inc(ErledigteAufgaben);
      end
      else
      begin
        sql.add(' and TRUE');
      end;

      for n := 0 to pred(lBAUSTELLE.count) do
      begin
        sql[pred(sql.count)] := ' and (BAUSTELLE_R=' + inttostr(lBAUSTELLE[n])
          + ')';
        SaveAs(SearchDir + format(cBaustelleIndexFName, [lBAUSTELLE[n]]));
        inc(ErledigteAufgaben);
        Label1.caption := inttostr(ErledigteAufgaben) + '/' + inttostr
          (AnzahlAufgaben);
        application.processmessages;
      end;

    end;
    cAUFTRAEGE.free;
    lBAUSTELLE.free;

  except
    on E: Exception do
    begin
      CareTakerLog(cERRORText + ' c_w_AuftragSuchindex(' + inttostr
          (BAUSTELLE_R) + '): ' + E.Message);
    end;
  end;
  Label1.caption := '#/#';

end;

procedure TFormAuftragSuchindex.ReCreateTheIndex;
begin
  show;
  doWork(BAUSTELLE_R);
  close;
end;

end.
