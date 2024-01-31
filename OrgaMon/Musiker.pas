{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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
unit Musiker;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Grids, IB_Grid, IB_Access,
  ExtCtrls, IB_UpdateBar, IB_Components,
  StdCtrls, IB_Controls, Buttons,
  WordIndex, ComCtrls;

type
  TFormMusiker = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton7: TSpeedButton;
    SpeedButton1: TSpeedButton;
    IB_Text1: TIB_Text;
    SpeedButton2: TSpeedButton;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    ListBox1: TListBox;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Button3: TButton;
    Button4: TButton;
    SpeedButton22: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ArtikelListe: TList;

    procedure DoTheMusikerSearch;
  public
    { Public-Deklarationen }
    procedure SetContext(RID: integer);
  end;

var
  FormMusiker: TFormMusiker;

implementation


uses
  Artikel, globals, anfix,
dbOrgaMon, gpLists,
  Funktionen_Basis,
  Funktionen_LokaleDaten,
  Funktionen_Beleg,
  wanfix, math, Datenbank;

{$R *.dfm}

procedure TFormMusiker.FormActivate(Sender: TObject);
begin
  if IB_query1.active then
    IB_Query1.refresh
  else
    IB_Query1.Open;
end;

procedure TFormMusiker.SpeedButton1Click(Sender: TObject);
begin
  BeginHourGlass;
  EnsureCache_Musiker;
  MusikerSuchIndex;
  EndHourGlass;
end;

procedure TFormMusiker.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DoTheMusikerSearch;
  end;
end;

procedure TFormMusiker.DoTheMusikerSearch;
var
  n: integer;
begin
  BeginHourGlass;
  if not (assigned(MusikerSearchWI)) then
  begin
    if FileExists(SearchDir + cMusikerSuchindexFName) then
    begin
      MusikerSearchWI := TWordIndex.create(nil);
      MusikerSearchWI.LoadFromFile(SearchDir + cMusikerSuchindexFName);
    end
    else
    begin
      MusikerSuchIndex;
    end;
  end
  else
  begin
    MusikerSearchWI.ReloadIfNew;
  end;

  MusikerSearchWI.Search(edit1.Text);
  if (MusikerSearchWI.FoundList.count > 0) then
  begin

    with IB_Query1 do
    begin
      close;
      for n := pred(sql.count) downto 0 do
        if (pos(cSQLwhereMarker, sql[n]) = 1) then
          break
        else
          sql.Delete(n);
      sql.Add('and RID in (');
      for n := 0 to pred(MusikerSearchWI.Foundlist.count) do
        if n = 0 then
          sql.add(inttostr(integer(MusikerSearchWI.FoundList[n])))
        else
          sql.add(',' + inttostr(integer(MusikerSearchWI.FoundList[n])));

      sql.add(') for update');
      Open;
    end;

  end
  else
  begin
    ShowMessage('Nichts gefunden!');
    edit1.SetFocus;
  end;
  EndHourGlass;
end;

procedure TFormMusiker.Button1Click(Sender: TObject);
var
  n: integer;
begin
  with IB_Query1 do
  begin
    close;
    for n := pred(sql.count) downto 0 do
      if pos(cSQLwhereMarker, sql[n]) = 1 then
        break
      else
        sql.Delete(n);

    sql.add('for update');
    Open;
  end;

end;

procedure TFormMusiker.Button2Click(Sender: TObject);
var
  TmpList: TList;
begin
  BeginHourGlass;
  TmpList := e_r_MusikerWerke(IB_Query1.FieldByName('RID').AsInteger);
  ArtikelListe.assign(TmpList);
  TmpList.free;
  FormArtikel.SetContext(ArtikelListe);
  EndHourGlass;
end;

procedure TFormMusiker.FormCreate(Sender: TObject);
begin
  ArtikelListe := TList.create;
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormMusiker.SetContext(RID: integer);
begin
  show;
  application.processmessages;
  IB_Query1.locate('RID', RID, []);
end;


procedure TFormMusiker.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  if not (CheckBox1.checked) then
    CheckBox1.caption := IB_Dataset.FieldByName('RID').AsString;
end;

procedure TFormMusiker.CheckBox1Click(Sender: TObject);
begin
  SpeedButton7.enabled := CheckBox1.checked;
  IB_Query1AfterScroll(IB_Query1);
end;

procedure TFormMusiker.SpeedButton7Click(Sender: TObject);
var
  TO_RID, FROM_RID: string;
  qTICKET: TdboQuery;
  TicketText : TStringList;
begin
  BeginHourGlass;
  TO_RID := CheckBox1.caption;
  FROM_RID := IB_Query1.FieldByNAme('RID').AsString;
  if (TO_RID <> FROM_RID) then
    if doit('Soll "' + e_r_MusikerName(StrToint(TO_RID)) + '"' + #13 +
      ' die Referenzen von "' + e_r_MusikerName(StrToint(FROM_RID)) + '"' + #13 +
      'übernehmen?' + #13 +
      'Darf ' + e_r_MusikerName(StrToint(FROM_RID)) + ' nun gelöscht werden') then
    begin

      // Log über diesen Haifisch anlegen
      qTICKET := nQuery;
      with qTICKET do
      begin
        sql.add('select * from TICKET');
        for_update(sql);
        Insert;
        FieldByName('RID').AsInteger := 0;
        FieldByName('ART').AsInteger := eT_KreativeZusammenfuehren;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        FieldByName('MOMENT').AsDateTime := now;

        TicketText := TStringList.create;
        TicketText.add('VORNAME='+IB_Query1.FieldByNAme('VORNAME').AsString);
        TicketText.add('NACHNAME='+IB_Query1.FieldByNAme('NACHNAME').AsString);
        TicketText.add('RID='+IB_Query1.FieldByNAme('RID').AsString);
        TicketText.add('NEU_VORNAME=' + e_r_sqls('select VORNAME from MUSIKER where RID='+TO_RID));
        TicketText.add('NEU_NACHNAME=' + e_r_sqls('select NACHNAME from MUSIKER where RID='+TO_RID));
        TicketText.add('NEU_RID=' + TO_RID);
        FieldByName('INFO').assign(TicketText);
        TicketText.free;

        Post;
      end;
      qTICKET.Free;

      //
      e_w_MusikerChangeRef(FROM_RID, TO_RID);
      e_x_sql('delete from MUSIKER where RID=' + FROM_RID);
    end;
  EndHourGlass;
  IB_Query1.refresh;
end;

procedure TFormMusiker.IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_Dataset.FieldByName('RID').IsNull then
    IB_Dataset.FieldByName('RID').AsInteger := 0;
end;

procedure TFormMusiker.SpeedButton22Click(Sender: TObject);
var
  qTICKET: TdboQuery;
  sINFO: TStringList;
  RIDs: TgpIntegerList;
  TO_RID,VORNAME,NACHNAME: string;
  n : integer;
  Stat_Aenderungen : integer;
begin
 if doit('Bisherige Zusammenführungen wiederholt anwenden') then
 begin

  BeginHourGlass;
  Stat_Aenderungen := 0;
  sINFO := TStringList.Create;
  qTICKET := nQuery;
  with qTICKET do
  begin
    sql.add('select * from TICKET where ART='+IntTostr(eT_KreativeZusammenfuehren) );
    for_update(sql);
    open;
    First;
    while not(eof) do
    begin
     e_r_sqlt(FieldByName('INFO'), sINFO);

     VORNAME := sINFO.Values['VORNAME'];
     NACHNAME := sINFO.Values['NACHNAME'];
     TO_RID  := sINFO.Values['NEU_RID'];

     RIDs := e_r_sqlm(
      {} 'select RID from MUSIKER where '+
      {} isSQLString('VORNAME',VORNAME)+'and'+
      {} isSQLString('NACHNAME',NACHNAME) );

     for n := 0 to pred(RIDs.count) do
     begin
       // Anwenden!
       e_w_MusikerChangeRef(IntToStr(RIDs[n]), TO_RID);
       e_x_sql('delete from MUSIKER where RID=' + IntToStr(RIDS[n]));
       inc(Stat_Aenderungen);
     end;

     if (RIDs.count>0) then
     begin
       edit;
       FieldByName('NUMMER').AsInteger := FieldByName('NUMMER').AsInteger + RIDs.Count;
       post;
     end;

     RIDs.free;
     next;

    end;
  end;
  qTICKET.Free;
  sINFO.Free;

   EndHourGlass;
   if (Stat_Aenderungen>0) then
    ShowMEssage('Heute '+IntToStr(Stat_Aenderungen)+' Änderungen!')
   else
    ShowMEssage('Heute keine Änderungen!')
  end;
 end;

procedure TFormMusiker.SpeedButton2Click(Sender: TObject);

  function NextMUSIKER_R: integer;
  begin
    result := succ(e_r_GEN('GEN_MUSIKER'));
  end;

  function NewEVL(MUSIKER_R, LastEVL: integer; Trenner: string): integer;
  begin
    result := NextMUSIKER_R;
    e_x_sql('insert into MUSIKER (RID,MUSIKER_R,EVL_TRENNER) values (0,' +
      inttostr(MUSIKER_R) + ',' +
      '''' + Trenner + ''')');
    if (LastEVL <> -1) then
      e_x_sql('update MUSIKER set EVL_R=' + inttostr(result) + ' where RID=' + inttostr(LastEVL));
  end;

var
  l, k: integer;
  OneS: string;
  LastEVL, RID: integer;
  ActDelimiter: string;
  ActName: string;

begin

  OneS := IB_Query1.FieldByName('NACHNAME').AsString;

  if (IB_query1.FieldByName('UEBER_INFO').IsNull) and ((pos('/', OneS) > 0) or (pos('&', OneS) > 0)) then
  begin
    RID := IB_Query1.FieldByName('RID').AsInteger;
    LastEVL := -1;

    //
    repeat

      k := pos('/', OneS);
      l := pos('&', OneS);

      if (k = 0) and (l > 0) then
        k := l;

      if (l > 0) and (k > 0) then
        k := min(k, l);

      if (k > 0) then
      begin
        ActDelimiter := OneS[k];
        ActName := cutblank(copy(OneS, 1, pred(k)));
      end
      else
      begin
        ActDelimiter := '';
        ActName := cutblank(OneS);
      end;

      if (LastEVL = -1) then
      begin
        e_x_sql('update MUSIKER set NACHNAME=''' + ActName + ''' where RID=' + inttostr(RID));
        LastEVL := NewEVL(RID, -1, ActDelimiter);
        e_w_MusikerChangeRef(inttostr(RID), inttostr(LastEVL));
      end
      else
      begin
        RID := NextMUSIKER_R;
        e_x_sql('insert into MUSIKER (RID,NACHNAME) values (0,''' + ActName + ''')');
        LastEVL := NewEVL(RID, LastEVL, ActDelimiter);
      end;

      if (k > 0) then
        OneS := copy(OneS, succ(k), MaxInt)
      else
        OneS := '';

    until (OneS = '');
    IB_query1.refresh;

  end
  else
  begin
    ShowMessage('kein &/ gefunden, oder Über-Info nicht leer!');
  end;
end;


procedure TFormMusiker.SpeedButton3Click(Sender: TObject);
begin
  BeginHourGlass;
  InvalidateCache_Musiker;
  EndHourGlass;
end;

procedure TFormMusiker.SpeedButton8Click(Sender: TObject);
begin
  with ListBox1 do
    if (ItemIndex <> -1) then
      ShowMessage(e_r_MusikerUeber(integer(items.objects[ItemIndex])));
end;

procedure TFormMusiker.Button3Click(Sender: TObject);
var
  TheList: TList;
  n: integer;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    TheList := e_r_MusikerGroup(integer(ListBox1.items.objects[ListBox1.ItemIndex]));
    with IB_Query1 do
    begin
      close;
      for n := pred(sql.count) downto 0 do
        if (pos(cSQLwhereMarker, sql[n]) = 1) then
          break
        else
          sql.Delete(n);
      sql.Add('and RID in (');
      for n := 0 to pred(TheList.count) do
        if (n = 0) then
          sql.add(inttostr(integer(TheList[n])))
        else
          sql.add(',' + inttostr(integer(TheList[n])));

      sql.add(') for update');
      Open;
    end;
    TheList.free;
  end;
  PageControl1.ActivePage := TabSheet1;
end;


procedure TFormMusiker.Button4Click(Sender: TObject);
begin
 // genau diese Gruppe!

end;



end.

