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
unit KontoAuswertung;

interface


uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  anfix32;

const
 Version : single = 1.003; // G:\rev\KostenKontrolle.rev

type
  TFormKontoAuswertung = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    ListBox2: TListBox;
    speichern: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    von: TLabel;
    bis: TLabel;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox2: TComboBox;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure speichernClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    KontoDaten      : TStringList;
    KontoSchluessel : TStringList;
    SubKonto        : TStringList;
    FehlerTexte     : TStringList;
  public
    { Public-Deklarationen }
    function IsHeader (s : string) : boolean;
    function GetSubCode (s : string) : string;
    function GetBetrag (s : string) : extended;
    function GetDatum (s : string) : TAnfixDate;
  end;

var
  FormKontoAuswertung: TFormKontoAuswertung;

implementation

uses
 wanfix32;

{$R *.DFM}

procedure TFormKontoAuswertung.Button1Click(Sender: TObject);
var
 n           : integer;
 KontoArt    : string;
 KontoArtOne : string;
begin
 KontoDaten.LoadFromFile(edit1.text);
 KontoSchluessel.clear;
 for n := 0 to pred(KontoDaten.Count) do
  if IsHeader(KontoDaten[n]) then
  begin
   KontoArt := GetSubCode(KontoDaten[n]);
   if KontoArt='' then
   begin
    FehlerTexte.add('['+inttostr(n)+'] keine Kontoart angegeben!');
   end else
   begin
    while true do
    begin
     KontoArtOne := cutblank(nextp(KontoArt,','));
     if KontoArtOne='' then
      break;
     if KontoSchluessel.indexof(KontoArtOne)=-1 then
     begin
      KontoSchluessel.add(KontoArtOne);
     end else
     begin
      // again a
     end;
    end;
   end;
  end;
 KontoSchluessel.sort;
 KontoSchluessel.Insert(0,'*');
 combobox1.items.AddStrings(KontoSchluessel);
 listbox1.items.assign(FehlerTexte);
end;

procedure TFormKontoAuswertung.FormCreate(Sender: TObject);
begin
 KontoDaten      := TStringList.create;
 KontoSchluessel := TStringList.create;
 SubKonto        := TStringList.create;
 FehlerTexte     := TStringList.create;
 caption := 'Kostenkontrolle Rev. '+RevTostr(Version);
end;

function TFormKontoAuswertung.IsHeader (s : string) : boolean;
begin
 result := false;
 if (length(s)>54) then
  if s[54]=',' then
   result := true;
end;

procedure TFormKontoAuswertung.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if (Key=#27) then
 begin
  Key := #0;
  close;
 end;
end;

procedure TFormKontoAuswertung.Button2Click(Sender: TObject);
var
 AddDataOK    : boolean;
 n            : integer;
 SollUmsatz   : extended;
 HabenUmsatz  : extended;
 GesamtUmsatz : extended;
 _Start       : TANFiXDate;
 _End         : TANFiXDate;
 _Dauer       : integer;
 habenUmsatzProMonat : double;
 SollUmsatzProMonat  : double;
begin
 _Start         := date2long(edit2.Text+'.'+edit4.Text);
 _End           := date2long(edit3.Text+'.'+edit4.Text);
 _Dauer         := succ(DateDiff(_start,_end));
 CurrencyString := comboBox2.text;
 AddDataOK := false;
 listbox2.clear;
 listbox2.Items.add('Konto   : '+edit1.text);
 listbox2.Items.add('Umsätze : "'+ComboBox1.Text+'" vom '+long2date(_start)+' bis '+long2date(_end)+' ('+inttostr(_dauer)+' Tage(e))');
 listbox2.Items.add('');
 SollUmsatz   := 0.0;
 HabenUmsatz  := 0.0;
 for n := 0 to pred(KontoDaten.count) do
 begin
  if IsHeader(KontoDaten[n]) then
  begin
   AddDataOK := (pos(ComboBox1.Text+',',GetSubCode(KontoDaten[n])+',')>0) or
                (ComboBox1.Text='*');

   if AddDataOK then
    AddDataOK := DateInside(GetDatum(KontoDaten[n]),_Start,_End);

   if AddDataOK then
    if CheckBox1.Checked then
     AddDataOK := KontoDaten[n][58]='H';

   if AddDataOK then
    if CheckBox2.Checked then
     AddDataOK := KontoDaten[n][58]='S';

   if AddDataOK then
   begin
    if KontoDaten[n][58]='S' then
     SollUmsatz := SollUmsatz - GetBetrag(KontoDaten[n])
    else
     HabenUmsatz := HabenUmsatz + GetBetrag(KontoDaten[n]);
//    listbox2.items.add(format('%12.2m',[HabenUmsatz]));
   end;
  end;
  if AddDataOK then
   listbox2.Items.add(copy(KontoDaten[n],1,58));
 end;
 GesamtUmsatz := HabenUmsatz + SollUmsatz;

 SollUmsatzProMonat   := (SollUmsatz/ _Dauer) * (365.0/ 12.0);
 habenUmsatzProMonat  := (habenUmsatz/ _Dauer) * (365.0/ 12.0);

 listbox2.Items.add('');
 listbox2.Items.add(format('Sollumsätze       %12.2m S    (%12.2m S / Monat)',[-SollUmsatz,-SollUmsatzProMonat]));
 listbox2.Items.add(format('Habenumsätze      %12.2m H    (%12.2m H / Monat)',[habenUmsatz,habenUmsatzProMonat]));
 listbox2.Items.add('                ================= ');
 if GesamtUmsatz>=0.0 then
  listbox2.Items.add(format('Gesamt            %12.2m H',[GesamtUmsatz]))
 else
  listbox2.Items.add(format('Gesamt            %12.2m S',[-GesamtUmsatz]))
end;

function TFormKontoAuswertung.GetSubCode (s : string) : string;
begin
 result := cutblank(copy(s,60,MaxInt));
end;

function TFormKontoAuswertung.GetBetrag (s : string) : extended;
begin
 s := cutblank(copy(s,44,13));
 ersetze('.','',s);
 ersetze(',','.',s);
 result := strtodouble(s);
end;

procedure TFormKontoAuswertung.speichernClick(Sender: TObject);
begin
 listbox2.items.saveToFile(edit1.text+'.Auswertung.txt');
 openShell(edit1.text+'.Auswertung.txt');
end;

function TFormKontoAuswertung.GetDatum (s : string) : TAnfixDate;
begin
 result := Date2long(copy(s,8,5)+'.'+Edit4.Text);
 listbox1.items.add(long2date(result));
end;

procedure TFormKontoAuswertung.Button3Click(Sender: TObject);
begin
 openShell(edit1.text);
end;

procedure TFormKontoAuswertung.FormDestroy(Sender: TObject);
begin
 KontoDaten.free;
 KontoSchluessel.free;
 SubKonto.free;
 FehlerTexte.free;
end;

end.
