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
unit PersonDoppelte;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  ComCtrls, StdCtrls,

  IB_Grid,
  IB_Components, IB_Access,


  Mask, IB_Controls, IB_NavigationBar,
  ExtCtrls, IB_SearchBar, IB_UpdateBar, IB_EditButton;

type
  TFormPersonDoppelte = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Label1: TLabel;
    Label2: TLabel;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Memo1: TIB_Memo;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button3: TButton;
    IB_Query3: TIB_Query;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    UserBreak: boolean;
    InsideCheck: boolean;
    function SetPerson(FromRID: integer): boolean;
  end;

var
  FormPersonDoppelte: TFormPersonDoppelte;

implementation

uses
  globals, anfix32,
  Funktionen_Beleg,
  Datenbank;

{$R *.DFM}

procedure TFormPersonDoppelte.FormActivate(Sender: TObject);
begin
  if not (IB_query1.active) then
    IB_query1.active := true;
  with IB_query2 do
  begin
    if not (Active) then
      Open;
    Prepare; // Re-Prepare the Query if the SQL was Invalidated.
  end;
  with IB_query3 do
  begin
    if not (Active) then
      Open;
    Prepare; // Re-Prepare the Query if the SQL was Invalidated.
  end;
end;

procedure TFormPersonDoppelte.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  if SetPerson(IB_Dataset.FieldByName('RID').AsInteger) then
    label1.caption := inttostr(IB_Dataset.FieldByName('RID').AsInteger)
  else
    label1.caption := 'LINK lost!';

  (*
  //  IndexField := 'PRIV_ANSCHRIFT_R';
  if FindKey([ IB_Query1.FieldByName('RID').AsInteger]) then
  begin
   label1.caption := FieldByName('VORNAME').AsString+' '+FieldByName('NACHNAME').AsString;
  end;
  *)
end;

function TFormPersonDoppelte.SetPerson(FromRID: integer): boolean;
begin
  result := false;
  with IB_query2 do // Ttable
  begin
    DisableControls;
    try
      Params.BeginUpdate; // Do not allow Search to happen until we have set all Params.
      try
        parambyname('CROSSREF').AsInteger := FromRID;
      finally
        Params.EndUpdate(True); // OK, the Params are all set, so the Search can be done now.
      end;
      if Active then
        Refresh
      else
        Open; // Display the new data.
    finally
      result := not (IsEmpty);
      EnableControls;
    end;
  end;
end;

procedure TFormPersonDoppelte.Button2Click(Sender: TObject);
var
  SuggestToKill: boolean;
  StartTime: dword;
  RecPos: integer;
  ReasonStr: string;

  _LastPLZ: string;
  _LastName: string;
  _LastStreet: string;
  _LastRID: integer;
  _LastNummer: integer;

  _ThisPLZ: string;
  _ThisName: string;
  _ThisStreet: string;
  _ThisRID: integer;
  _ThisNummer: integer;

  procedure OneMustDie;
  begin
    if (_ThisNummer < _LastNummer) then
    begin
   // lösche _LastNummer
      listbox1.Items.add(inttostr(_LastRID) + ';' + ReasonStr);
    end else
    begin
   // lösche _ThisNummer
      listbox1.Items.add(inttostr(_ThisRID) + ';' + ReasonStr);
    end;
  end;

begin
  if InsideCheck then
  begin
    InsideCheck := false;
    UserBreak := true;
  end else
  begin
    _LastPLZ := '';
    _LastName := '';
    _LastStreet := '';
    _LastRID := 0;
    _LastNummer := 0;
    UserBreak := false;
    InsideCheck := true;
    IB_Query1.DisableControls;
    IB_Query2.DisableControls;
    StartTime := 0;
    with IB_Query1 do
    begin
      progressbar1.max := RecordCount;
      progressbar1.position := 0;
      RecPos := 0;
      first;
      while not (eof) do
      begin

        if frequently(StartTime, 400) then
        begin
          progressbar1.position := RecPos;
          if UserBreak then
            break;
          application.processmessages;
        end;

        SuggestToKill := false;

        repeat

          _ThisRID := FieldByName('RID').AsInteger;
          _ThisPLZ := noblank( e_r_land(IB_Query1)+
          e_r_plz(IB_Query1) );
          _ThisStreet := ansiUpperCase(noblank(FieldByName('STRASSE').AsString));
          ersetze('.', '', _ThisStreet);
          ersetze('-', '', _ThisStreet);
          ersetze('STRASSE', '', _ThisStreet);
          ersetze('STRAßE', '', _ThisStreet);
          ersetze('STR', '', _ThisStreet);


          if not (SetPerson(FieldByName('RID').AsInteger)) then
          begin
            SuggestToKill := true;
            ReasonStr := 'KEINE PERSON';
            break;
          end;

          with IB_query2 do
          begin
            _ThisName := ansiuppercase(noblank(FieldByName('VORNAME').AsString + FieldByName('NACHNAME').AsString));
            _THisNummer := FieldByName('NUMMER').AsInteger;
          end;

          if _ThisPLZ = _LastPLZ then
          begin

            if _ThisName = _LastName then
            begin
              ReasonStr := 'NAME=' + _LastName;
              OneMustDie;
              break;
            end;

            if _ThisStreet = _LastSTreet then
            begin
              ReasonStr := 'STRASSE=' + _LastStreet;
              OneMustDie;
              break;
            end;

          end;

        until true;

        if SuggestToKill then
        begin
          listbox1.items.add(
           {} inttostr(FieldByName('RID').AsInteger) + ';' +
           {} ReasonStr + ';' +
           {} HugeSingleLine(e_r_ort(IB_Query1),'',1,true)
            );
        end;

        _LastPLZ := _ThisPLZ;
        _LastName := _ThisName;
        _LastStreet := _ThisStreet;
        _LastRID := _ThisRID;
        _LastNummer := _ThisNummer;
        inc(RecPos);
        next;
      end;
    end;
    IB_Query1.EnableControls;
    IB_Query2.EnableControls;
    listbox1.items.SaveToFile(MyProgramPath + 'Doppelte Bericht.txt');
  end;
  progressbar1.position := 0;
end;

procedure TFormPersonDoppelte.Button3Click(Sender: TObject);
begin
  listbox1.items.LoadFromFile(MyProgramPath + 'Doppelte Bericht.txt');
end;

procedure TFormPersonDoppelte.Button1Click(Sender: TObject);
var
  ToDeleteRID: integer;
  AllDataStr: string;
  n: integer;
  ToDelFound: boolean;
  StartTime: dword;
begin
  IB_Query2.DisableControls;
  IB_Query3.DisableControls;
  progressbar1.position := 0;
  progressbar1.max := pred(Listbox1.items.count);
  StartTime := 0;
  for n := 0 to pred(Listbox1.items.count) do
  begin

    if frequently(StartTime, 400) then
    begin
      progressbar1.position := n;
      application.processmessages;
    end;
    AllDataStr := listbox1.items[n];
    ToDeleteRID := strtoint(nextp(AllDataStr, ';'));

    with IB_Query3 do
    begin
      ToDelFound := false;
      try
        Params.BeginUpdate; // Do not allow Search to happen until we have set all Params.
        try
          parambyname('CROSSREF').AsInteger := ToDeleteRID;
        finally
          Params.EndUpdate(True); // OK, the Params are all set, so the Search can be done now.
        end;
        if Active then
          Refresh
        else
          Open; // Display the new data.
      finally
        ToDelFound := not (IsEmpty);
        EnableControls;
      end;
      if (ToDelFound) then
      begin
        if SetPerson(ToDeleteRID) then
          IB_Query2.delete;
        delete;
      end;
    end;
  end;
  IB_Query3.EnableControls;
  IB_Query2.EnableControls;
  progressbar1.position := 0;
end;

end.
