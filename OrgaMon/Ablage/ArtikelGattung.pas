unit ArtikelGattung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, paramchklist, ib_components,
  JvComCtrls, ComCtrls;

type
  TFormArtikelGattung = class(TForm)
    ParamCheckList1: TParamCheckList;
    Edit1: TEdit;
    JvTreeView1: TJvTreeView;
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    Gattung: TStringList;
    ARTIKEL_R: integer;
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelGattung: TFormArtikelGattung;

implementation

{$R *.dfm}

type
  THeaderNode = class(TObject)
    Node: TTreeNode;
    Header: string;
  end;

procedure TFormArtikelGattung.FormActivate(Sender: TObject);


var
  cGATTUNG: TIB_Cursor;

  LastHeader: string;
  ThisHeader: string;
  HeaderLevel: integer;

  HeaderNodes: TList;
  RecN: integer;

  NodeText: string;
  NodeRID: integer;
  n: integer;


  function _add(MainCategorie: TTreeNode; const cHeader, cText: string; const cRID: integer): TTreeNode;
  begin

    // In den Tree-View eintragen
    with JvTreeView1 do
      if assigned(MainCategorie) then
        result := items.AddChildObject(MainCategorie, cText, TObject(cRID))
      else
        result := items.addObject(nil, cText, TObject(cRID));

   // In der Node-Liste verzeichnen
    with THeaderNode.create do
    begin
      Node := result;
      Header := cHeader;
      HeaderNodes.add(self);
    end;

  end;

begin

  if not (assigned(Gattung)) then
  begin
    HeaderLevel := -1;
    HeaderNodes := TList.create;

    Gattung := TStringList.create;
    cGATTUNG := TIB_Cursor.create(self);
    LastHeader := '';
    with cGattung, JvTreeView1 do
    begin
      items.BeginUpdate;
      sql.add('SELECT RID,CODE,BEZEICHNUNG FROM GATTUNG ORDER BY CODE');
      APIFirst;
      RecN := 0;
      while not (eof) do
      begin
        ThisHeader := FieldByName('CODE').AsString;
        inc(RecN);

        NodeText :=
          ThisHeader + ' ' +
          FieldByName('BEZEICHNUNG').AsString + ' ' +
          '[' +
          inttostr(RecN) +
          ']';
        NodeRID := FieldByName('RID').AsInteger;

        // Gattung,
        Gattung.addobject(NodeText, TObject(NodeRID));

        // aktuellen String in den Baum einhängen
        for n := pred(HeaderNodes.count) downto 0 do
          with THeaderNode(HeaderNodes[n]) do
            if (pos(Header, ThisHeader) = 1) then
            begin
              _add(Node, ThisHeader, NodeText, NodeRID);
              break;
            end else
            begin
              // this do not work, purge the chain
//              THeaderNode(HeaderNodes[n]).free;
              HeaderNodes.delete(n);
            end;

        if HeaderNodes.count = 0 then
          _add(nil, ThisHEader, NodeText, NodeRID);

        LastHeader := ThisHeader;
        ApiNext;
      end;
      items.EndUpdate;
    end;

    cGATTUNG.free;
    ParamChecklist1.items.addstrings(Gattung);
  end;

end;

end.

