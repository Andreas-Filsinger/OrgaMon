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
unit ArtikelSuchindex;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, ComCtrls, IB_Components;

type
  TFormArtikelSuchindex = class(TForm)
    ProgressBar1: TProgressBar;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure MakeIndex;
  end;

var
  FormArtikelSuchindex: TFormArtikelSuchindex;

implementation

uses
  globals, WordIndex, anfix32,
  gplists,  Datenbank,
  IB_Access,
  Funktionen.Basis,
  Funktionen.Beleg,
  Funktionen.Auftrag,

  { imp pend : Routinen verschieben e_?_Verlag }
  { imp pend : OLAP ohne GUI }
  OLAP;

{$R *.DFM}

procedure TFormArtikelSuchindex.Button1Click(Sender: TObject);
var
  RecNu: integer;
  StartTime: dword;
  ArtikelInfo: TStringList;
  cARTIKEL: TIB_Cursor;
  WebShopRedList: TgpIntegerList;
  s: string;
  n: integer;
  SearchIndex: TWordIndex;

  // cache
  ARTIKEL_R : integer;

  // verschiedene Suchstrings
  ArtikelContext1: string;
  ArtikelContext2: string;

  // die verschiedenen OLAPs für die verschiedenen Name-Spaces
  OLAPs: TStringList;
  RIDs: TList;
  SearchIndexs: TList;

  function ReadLongStr(BlockName: string): string;
  var
    MachineState: byte;
    n, k: integer;
  begin
    result := '';
    MachineState := 0;
    for n := 0 to pred(ArtikelInfo.count) do
    begin
      case MachineState of
        0:
        begin
          k := pos(BlockName + '=', ArtikelInfo[n]);
          if (k = 1) then
          begin
            result := copy(ArtikelInfo[n], length(BlockName) + 2, MaxInt);
            MachineState := 1;
          end;
        end;
        1:
        begin
          k := pos('=', ArtikelINfo[n]);
          if (k = 0) or (k > 11) then
            result := result + #13 + ArtikelInfo[n]
          else
            exit;
        end;
      end;
    end;
  end;

begin
  BeginHourGlass;

  ArtikelInfo := TStringList.create;
  OLAPs := TStringList.create;
  RIDs := TList.create;
  SearchIndexs := TList.create;
  cARTIKEL := DataModuleDatenbank.nCursor;
  SearchIndex := TWordIndex.create(nil);

  // OLAPs ausführen!
  dir(iOlapPath+'System.WebShop.*'+cOLAPExtension,OLAPs,false);
  for n := 0 to pred(OLAPs.count) do
  begin
    RIDs.add(FormOLAP.OLAP(OLAPs[n]));
    SearchIndexs.add(TWordIndex.create(nil));
  end;

  // den Namespace extrahieren!
  ersetze('System.WebShop.','',OLAPs);
  ersetze(cOLAPExtension,'',OLAPs);

  // den Namespace "abu" erzwingen!
  if (OLAPs.indexof('abu')=-1) then
  begin
    OLAPs.add('abu');
    RIDs.add(e_r_sqlm('select RID from ARTIKEL'));
    SearchIndexs.add(TWordIndex.create(nil));
  end;

  // Verbot für den WebShop
  WebShopRedList := e_r_sqlm(
    'select '+
    ' ARTIKEL.RID '+
    'from '+
    ' ARTIKEL '+
    'where '+
    ' (ARTIKEL.WEBSHOP=''N'') or '+
    ' (ARTIKEL.SORTIMENT_R in ('+
    'select RID from SORTIMENT where WEBSHOP=''N'''+
    ')) ');

  RecNu := 0;
  StartTime := 0;

  with cARTIKEL do
  begin
    sql.add('SELECT');
    sql.add(' RID,INTERN_INFO,TITEL,VERLAG_R,');
    sql.add(' KOMPONIST_R,ARRANGEUR_R,CODE,');
    sql.add(' NUMERO,VERLAGNO,SORTIMENT_R,LAUFNUMMER,');
    sql.add(' WEBSHOP,GEMA_WN');
    sql.add('FROM');
    sql.add(' ARTIKEL');
    sql.add('WHERE');
    sql.add(' PAKET_R IS NULL');
    Open;
    EnsureHourGlass;
    progressbar1.max := RecordCount;
    progressbar1.position := 0;
    APIfirst;
    while not (eof) do
    begin

      ARTIKEL_R := FieldByName('RID').AsINteger;


      FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);

      // Grundvolumen aller Clients
      S :=
        FieldByName('TITEL').AsString + ' ' +
        e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger) + ' ' +
        FieldByName('GEMA_WN').AsString;

      // intern Hebu
      ArtikelContext1 :=
        S + ' ' +
        FieldByName('CODE').AsString + ' ' +
        FieldByName('NUMERO').AsString + ' ' +
        FieldByName('VERLAGNO').AsString + ' ' +
        '~' + FieldByName('SORTIMENT_R').AsString + 's ' +
        ArtikelInfo.Values['SERIE'] + ' ' +
        ReadLongStr('BEM') + ' ' +
        ArtikelInfo.Values['GATTUNG'];

      // extern Hebu
      ArtikelContext2 :=
        S + ' ' +
        FieldByName('LAUFNUMMER').AsString;

      SearchIndex.AddWords(ArtikelContext1, TObject(ARTIKEL_R));

      // ist die Aufnahme des Artikels in den WebShop OK?
      if (WebShopRedList.indexof(ARTIKEL_R)=-1) then
      begin

        // alle OLAPs durchlaufen und Wortlisten aufbauen ...
        for n := 0 to pred(OLAPs.count) do
          if (TgpIntegerList(RIDs[n]).IndexOf(ARTIKEL_R)<>-1) then
          begin
            if (pos('2',OLAPs[n])>0) then
              TWordIndex(SearchIndexs[n]).AddWords(ArtikelContext2, TObject(ARTIKEL_R))
            else
              TWordIndex(SearchIndexs[n]).AddWords(ArtikelContext1, TObject(ARTIKEL_R));
          end;

      end;

      ApiNext;
      inc(RecNu);
      if frequently(StartTime, 400) or eof then
      begin
        application.processmessages;
        Progressbar1.Position := RecNu;
      end;
    end;
    Close;
  end;

  SearchIndex.JoinDuplicates(false);
  SearchIndex.SaveToFile(SearchDir + format(cArtikelSuchindexFName,[cArtikelSuchindexIntern]));

  for n := 0 to pred(OLAPs.Count) do
    with TWordIndex(SearchIndexs[n]) do
    begin
      JoinDuplicates(false);
      SaveToFile(SearchDir + format(cArtikelSuchindexFName,[OLAPs[n]]));
    end;

  // FREE
  SearchIndex.free;
  ArtikelInfo.free;
  OLAPs.free;
  for n := 0 to pred(RIDs.count) do
    TgpIntegerList(RIDs[n]).free;
  RIDs.free;
  for n := 0 to pred(SearchIndexs.count) do
    TWordIndex(SearchIndexs[n]).free;
  SearchIndexs.free;

  EndHourGlass;
  close;
end;

procedure TFormArtikelSuchindex.MakeIndex;
begin
  show;
  Button1Click(self);
end;

end.

