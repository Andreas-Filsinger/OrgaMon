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
unit AuftragSuche;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, JvGIF, ExtCtrls,
  // 22.04.09: Ronny Schupeta
  // Unit globals und FavoritenSQL hinzugefügt
  globals, FavoritenSQL, Mask, IB_Controls, IB_EditButton;

type
  TFormAuftragSuche = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Edit2: TEdit;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button3: TButton;
    Label10: TLabel;
    Edit7: TEdit;
    Button4: TButton;
    Image3: TImage;
    Image1: TImage;
    Label11: TLabel;
    Edit8: TEdit;
    Button5: TButton;
    Label12: TLabel;
    ComboBox1: TComboBox;
    Button7: TButton;
    IB_Date2: TIB_Date;
    Label13: TLabel;
    Label14: TLabel;
    IB_Date1: TIB_Date;
    Button8: TButton;
    IB_Date3: TIB_Date;
    Label15: TLabel;
    Label16: TLabel;
    IB_Date4: TIB_Date;
    Button9: TButton;
    Edit9: TEdit;
    Label17: TLabel;
    Edit10: TEdit;
    Label18: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private-Deklarationen }

    FreeSQLFavorites:   TFavoriteList;

    // 23.04.09: Ronny Schupeta (Siehe Definition)
    procedure RefreshFreeSQLFavorites;
  public
    { Public-Deklarationen }

    function extraSQLCode: boolean;
    procedure AddExtraFields(s: TStrings);

    function eMonteur_Info: string;
    function eZaehler_Info: string;
    function eIntern_Info: string;
  end;

var
  FormAuftragSuche: TFormAuftragSuche;

// 22.04.09: Ronny Schupeta (Siehe Definition)
function WellPQ(const S: String): String;

implementation

uses
  AuftragArbeitsplatz, anfix32, CareTakerClient,
  txlib, txlib_UI, wanfix32;

{$R *.dfm}

// 22.04.09: Ronny Schupeta
// Ermittelt alle gültigen Zeichen für die unscharfe Suche
// nach einem Planquadrat.
function WellPQ(const S: String): String;
const
  Allowed = '0123456789.';
var
  i, l: Integer;
begin
  result := '';

  l := Length(S);
  for i := 1 to l do
    if Pos(S[i], Allowed) > 0 then
      result := result + S[i];
end;

// 23.04.09: Ronny Schupeta
// Vergleichsfunktion für Case-Insensitive-Sortierung
function StrList_Compare(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := CompareStr(TXLowerCase(List.Strings[Index1]), TXLowerCase(List.Strings[Index2]));
end;

// 23.04.09: Ronny Schupeta
// Aktualisiert die ComboBox mit aktuellen Favoriten für "freies SQL"
procedure TFormAuftragSuche.RefreshFreeSQLFavorites;
var
  I, C:     Integer;
  TmpList:  TStringList;
begin
  ComboBox1.Clear;

  FreeSQLFavorites.LoadFromFile(iOlapPath + cAuftragLupeFavoritenFName);

  TmpList := TStringList.Create;

  try
    C := FreeSQLFavorites.Count - 1;
    for I := 0 to C do
      TmpList.AddObject(FreeSQLFavorites.Items[I].Caption, FreeSQLFavorites.Items[I]);

    TmpList.CustomSort(StrList_Compare);

    ComboBox1.Items.AddStrings(TmpList);

    ComboBox1.Text := '[ Bitte wählen ]';
  finally
    TmpList.Free;
  end;
end;

procedure TFormAuftragSuche.AddExtraFields(s: TStrings);
begin
  if (edit4.text <> '') then
    s.add(' ,MONTEUR_INFO');
  if (edit5.text <> '') then
    s.add(' ,ZAEHLER_INFO');
  if (edit6.text <> '') then
    s.add(' ,INTERN_INFO');
end;

procedure TFormAuftragSuche.Button1Click(Sender: TObject);
begin
  // 21.04.09: Ronny Schupeta
  // .Close vor FormAuftragArbeitsplatz.Suche durchführen
  close;
  FormAuftragArbeitsplatz.MarkImportedRID(strtointdef(edit1.text, 0));
end;

procedure TFormAuftragSuche.Button2Click(Sender: TObject);
begin
  close;
  FormAuftragArbeitsplatz.Suche;
end;

procedure TFormAuftragSuche.Button3Click(Sender: TObject);
begin
  edit2.text := '';
  edit3.text := '';
  edit4.text := '';
  edit5.text := '';
  edit6.text := '';
  edit9.text := '';
  edit10.text := '';
  Memo1.lines.clear;

  close;
end;

procedure TFormAuftragSuche.Button4Click(Sender: TObject);
begin
  // 21.04.09: Ronny Schupeta
  // .Close vor FormAuftragArbeitsplatz.Suche durchführen
  //close;
  //FormAuftragArbeitsplatz.MarkProtokollValue(edit7.text);

  Button2.Click;
end;

// 21.04.09: Ronny Schupeta
//           Ermittelt alle RIDs zu einem Planquadrat.
procedure TFormAuftragSuche.Button5Click(Sender: TObject);
begin
  Button2.Click;
end;

function TFormAuftragSuche.eMonteur_Info: string;
begin
  result := edit4.text;
end;

function TFormAuftragSuche.eZaehler_Info: string;
begin
  result := edit5.text;
end;

procedure TFormAuftragSuche.FormCreate(Sender: TObject);
begin
  FreeSQLFavorites := TFavoriteList.Create;
end;

procedure TFormAuftragSuche.FormDestroy(Sender: TObject);
begin
  FreeSQLFavorites.Free;
end;

// 23.04.09: Ronny Schupeta
// FormShow wurde hinzugefügt
procedure TFormAuftragSuche.FormShow(Sender: TObject);
begin
  if not FileExists(iOlapPath + cAuftragLupeFavoritenFName) then
  begin
    FreeSQLFavorites.Clear;

    try
      FreeSQLFavorites.SaveToFile(iOlapPath + cAuftragLupeFavoritenFName);
    except
      on E: Exception do WarningMsg('Warnung:' + #13 + 'Das Anlegen einer neuen Datei für freies SQL - Favoriten ist gescheitert.' + #13#13 + E.Message);
    end;
  end;

  RefreshFreeSQLFavorites;
end;

procedure TFormAuftragSuche.Image1Click(Sender: TObject);
begin
  openShell(cTixURL + 'Auftrag.Suche');
end;

procedure TFormAuftragSuche.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Auftrag.Suche');
end;

function TFormAuftragSuche.eIntern_Info: string;
begin
  result := edit6.text;
end;

function TFormAuftragSuche.extraSQLCode: boolean;
begin
  result :=
    (edit2.text <> '') or
    (edit3.text <> '') or
    (edit4.text <> '') or
    (edit5.text <> '') or
    (edit6.text <> '') or
    (Memo1.lines.count > 0)
end;

procedure TFormAuftragSuche.Button7Click(Sender: TObject);
begin
  with FormSQLFavoriten do
  begin
    TempFav.Assign(FreeSQLFavorites);

    ShowModal;

    if not Canceled then
    begin
      FreeSQLFavorites.Assign(TempFav);

      try
        FreeSQLFavorites.SaveToFile(iOlapPath + cAuftragLupeFavoritenFName);
      except
        on E: Exception do ErrorMsg('Fehler:' + #13 + 'Das Speichern der Datei für freies SQL - Favoriten schlug fehl.' + #13#13 + E.Message);
      end;

      RefreshFreeSQLFavorites;
    end;
  end;
end;

procedure TFormAuftragSuche.Button8Click(Sender: TObject);
begin
  Button2.Click;
end;

procedure TFormAuftragSuche.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex >= 0 then
    Memo1.Text := TFavoriteItem(ComboBox1.Items.Objects[ComboBox1.ItemIndex]).SQL;
end;

end.

