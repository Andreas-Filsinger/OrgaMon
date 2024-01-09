(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007 - 2024  Andreas Filsinger

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

    https://wiki.orgamon.org/

*)
unit FavoritenSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFavoriteList = class;

  TFavoriteItem = class
  private
    FOwner: TFavoriteList;

    FCaption: String;
    FSQL:     String;

    function GetIndex: Integer;
  public
    constructor Create(Owner: TFavoriteList);

    procedure Assign(Source: TFavoriteItem);

    property Caption: String read FCaption write FCaption;
    property SQL: String read FSQL write FSQL;

    property Index: Integer read GetIndex;

    property Owner: TFavoriteList read FOwner;
  end;

  TFavoriteList = class
  private
    FItems: TList;

    function GetItem(Index: Integer): TFavoriteItem;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TFavoriteList);

    procedure LoadFromFile(const Filename: String);
    procedure SaveToFile(const Filename: String);

    procedure Clear;

    function Add: TFavoriteItem;
    procedure Delete(Index: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    property Items[Index: Integer]: TFavoriteItem read GetItem;
    property Count: Integer read GetCount;
  end;

type
  TFormSQLFavoriten = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    Button3: TButton;
    Button4: TButton;
    Panel4: TPanel;
    LabeledEdit1: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView1Editing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    Canceled: Boolean;

    TempFav:  TFavoriteList;

    procedure UpdateCtrls;
    procedure UpdateListView;
  end;

var
  FormSQLFavoriten: TFormSQLFavoriten;

implementation

{$R *.dfm}

uses
 txXML, wanfix;

constructor TFavoriteItem.Create(Owner: TFavoriteList);
begin
  if not Assigned(Owner) then
    raise Exception.Create('TFavoriteList Object darf nicht nil sein.')
  else if not (Owner is TFavoriteList) then
    raise Exception.Create('Object muss vom Typ TFavoriteList sein.');

  FOwner := Owner;
end;

procedure TFavoriteItem.Assign(Source: TFavoriteItem);
begin
  FCaption := Source.FCaption;
  FSQL := Source.FSQL;
end;

function TFavoriteItem.GetIndex: Integer;
var
  I, C: Integer;
begin
  Result := -1;

  C := FOwner.Count - 1;
  for I := 0 to C do
    if FOwner.Items[i] = Self then
    begin
      Result := I;
      Break;
    end;
end;

constructor TFavoriteList.Create;
begin
  FItems := TList.Create;
end;

destructor TFavoriteList.Destroy;
begin
  Clear;

  FItems.Free;

  inherited;
end;

procedure TFavoriteList.Assign(Source: TFavoriteList);
var
  I, C: Integer;
begin
  Clear;

  C := Source.Count - 1;
  for I := 0 to C do
    Add.Assign(Source.Items[I]);
end;

procedure TFavoriteList.LoadFromFile(const Filename: String);
var
  XML:  TTXXMLDocument;

  procedure LoadDocument(XMLNode: TTXXMLNodeElement);
  var
    SubNode:  TTXXMLNodeElement;
    NodeName: String;
    I, C:     Integer;

    procedure LoadFavorites(XMLNode: TTXXMLNodeElement);
    var
      SubNode:  TTXXMLNodeElement;
      NodeName: String;
      I, C:     Integer;

      procedure LoadItems(XMLNode: TTXXMLNodeElement);
      var
        SubNode:  TTXXMLNodeElement;
        NodeName: String;
        I, C:     Integer;

        procedure LoadItem(XMLNode: TTXXMLNodeElement);
        var
          SubNode:  TTXXMLNodeElement;
          NodeName: String;
          Item:     TFavoriteItem;
          I, C:     Integer;
        begin
          Item := Add;

          C := XMLNode.Count - 1;
          for I := 0 to C do
            if XMLNode.NodeTypes[I] = dtElement then
            begin
              SubNode := XMLNode.Elements[I];
              NodeName := LowerCase(SubNode.NodeName);

              if NodeName = 'caption' then
                Item.Caption := GetXMLText(SubNode)
              else if NodeName = 'sql' then
                Item.SQL := GetXMLText(SubNode);
            end;
        end;
      begin
        C := XMLNode.Count - 1;
        for I := 0 to C do
          if XMLNode.NodeTypes[I] = dtElement then
          begin
            SubNode := XMLNode.Elements[I];
            NodeName := LowerCase(SubNode.NodeName);

            if NodeName = 'item' then
              LoadItem(SubNode);
          end;
      end;
    begin
      C := XMLNode.Count - 1;
      for I := 0 to C do
        if XMLNode.NodeTypes[I] = dtElement then
        begin
          SubNode := XMLNode.Elements[I];
          NodeName := LowerCase(SubNode.NodeName);

          if NodeName = 'items' then
          begin
            LoadItems(SubNode);
            Break;
          end;
        end;
    end;
  begin
    C := XMLNode.Count - 1;
    for I := 0 to C do
      if XMLNode.NodeTypes[I] = dtElement then
      begin
        SubNode := XMLNode.Elements[I];
        NodeName := LowerCase(SubNode.NodeName);

        if NodeName = 'favorites' then
        begin
          LoadFavorites(SubNode);
          Break;
        end;
      end;
  end;
begin
  XML := TTXXMLDocument.Create;

  try
    XML.LoadFromFile(Filename);

    Clear;

    LoadDocument(XML.Document);
  finally
    XML.Free;
  end;
end;

procedure TFavoriteList.SaveToFile(const Filename: String);
var
  XML:  TTXXMLDocument;

  procedure SaveDocument(XMLNode: TTXXMLNodeElement);
  var
    I, C: Integer;
  begin
    C := Count - 1;
    with XMLNode.AddElement('favorites').AddElement('items') do
      for I := 0 to C do
        with AddElement('item') do
        begin
          AddElement('caption').AddText(Items[I].Caption, True);
          AddElement('sql').AddText(Items[I].SQL, True);
        end;
  end;
begin
  XML := TTXXMLDocument.Create;

  try
    SaveDocument(XML.Document);

    XML.SaveToFile(Filename);
  finally
    XML.Free;
  end;
end;

procedure TFavoriteList.Clear;
var
  I, C: Integer;
begin
  C := Count - 1;
  for I := 0 to C do
    Items[I].Free;

  FItems.Clear;
end;

function TFavoriteList.Add: TFavoriteItem;
begin
  Result := TFavoriteItem.Create(Self);

  with Result do
    Caption := 'Neuer Favorit';

  FItems.Add(Pointer(Result));
end;

procedure TFavoriteList.Delete(Index: Integer);
begin
  Items[Index].Free;
  FItems.Delete(Index);
end;

procedure TFavoriteList.Move(CurIndex, NewIndex: Integer);
begin
  FItems.Move(CurIndex, NewIndex);
end;

function TFavoriteList.GetItem(Index: Integer): TFavoriteItem;
begin
  Result := TFavoriteItem(FItems.Items[Index]);
end;

function TFavoriteList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TFormSQLFavoriten.UpdateCtrls;
var
  E:  Boolean;
begin
  E := Assigned(ListView1.Selected);
  if not E then
  begin
    LabeledEdit1.Text := '';
    Memo1.Text := '';
  end;

  LabeledEdit1.Enabled := E;
  Memo1.Enabled := E;
  Button4.Enabled := E;
end;

procedure TFormSQLFavoriten.UpdateListView;
var
  I, C: Integer;
begin
  ListView1.Clear;

  C := TempFav.Count - 1;
  for I := 0 to C do
    with ListView1.Items.Add do
    begin
      Caption := TempFav.Items[I].Caption;
      Data := Pointer(TempFav.Items[I]);
    end;

  UpdateCtrls;
end;

procedure TFormSQLFavoriten.FormCreate(Sender: TObject);
begin
  TempFav := TFavoriteList.Create;
end;

procedure TFormSQLFavoriten.FormDestroy(Sender: TObject);
begin
  TempFav.Free;
end;

procedure TFormSQLFavoriten.FormShow(Sender: TObject);
begin
  Canceled := True;

  ListView1.Tag := 0;

  UpdateListView;
end;

procedure TFormSQLFavoriten.LabeledEdit1Change(Sender: TObject);
var
  S:  String;
begin
  if Assigned(ListView1.Selected) then
  begin
    S := Trim(LabeledEdit1.Text);

    ListView1.Selected.Caption := S;
    TFavoriteItem(ListView1.Selected.Data).Caption := S;
  end;
end;

procedure TFormSQLFavoriten.Memo1Change(Sender: TObject);
begin
  if Assigned(ListView1.Selected) then
    TFavoriteItem(ListView1.Selected.Data).SQL := Memo1.Text;
end;

procedure TFormSQLFavoriten.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
    if Assigned(Item) then
      with TFavoriteItem(Item.Data) do
      begin
        LabeledEdit1.Text := Caption;
        Memo1.Text := SQL;
      end;

  UpdateCtrls;
end;

procedure TFormSQLFavoriten.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ListView1.Tag := 1 - ListView1.Tag;
  ListView1.AlphaSort;
end;

procedure TFormSQLFavoriten.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if ListView1.Tag = 0 then
    Compare := CompareStr(AnsiLowerCase(Item1.Caption), AnsiLowerCase(Item2.Caption))
  else
    Compare := CompareStr(AnsiLowerCase(Item2.Caption), AnsiLowerCase(Item1.Caption));
end;

procedure TFormSQLFavoriten.ListView1Editing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TFormSQLFavoriten.Button3Click(Sender: TObject);
var
  Favorite: TFavoriteItem;
begin
  Favorite := TempFav.Add;

  with ListView1.Items.Add do
  begin
    Data := Pointer(Favorite);
    Selected := True;
    Caption := Favorite.Caption;
    LabeledEdit1.Text := Favorite.Caption;
  end;

  LabeledEdit1.SetFocus;
end;

procedure TFormSQLFavoriten.Button4Click(Sender: TObject);
var
  ListItem: TListItem;
  I:        Integer;
begin
  ListItem := ListView1.Selected;
  if Assigned(ListItem) then
    if doit('Soll der Eintrag wirklich entfernt werden?') then
    begin
      TFavoriteItem(ListItem.Data).Owner.Delete(TFavoriteItem(ListItem.Data).Index);

      I := ListItem.Index;

      ListItem.Delete;
      if I < ListView1.Items.Count then
        ListView1.Items.Item[I].Selected := True;

      UpdateCtrls;
    end;
end;

procedure TFormSQLFavoriten.Button1Click(Sender: TObject);
begin
  Canceled := False;
  Close;
end;

procedure TFormSQLFavoriten.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
