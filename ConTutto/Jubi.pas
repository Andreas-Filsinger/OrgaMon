unit Jubi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls;

type
  TJubiForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    ListBox1: TListBox;
    Timer1: TTimer;
    Button1: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
    AllData: TstringList;
    AllUp: TstringList;
    Initialized: boolean;
    ActInfos: integer;
    InpStr: string;
  public
    { Public-Deklarationen }
    procedure ImportAndCreate;
    procedure Loadall;
    procedure SelectAll;
    procedure SetInfo;
    procedure LoadInfosFor(index: integer);
    function NextP: string;
    procedure DoSearch;
    procedure MakeAbfrage;
  end;

var
  JubiForm: TJubiForm;

implementation

uses
  anfix32, globals, HebuBase;

{$R *.DFM}

procedure TJubiForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_return) then
    DoSearch;
end;

procedure TJubiForm.DoSearch;
var
  n: integer;
  ToFind: string;
  g, s, j: integer;
  NameStr: string;
  NumStr: string;
  diff: integer;

  function ToNumber(const x: string): integer;
  begin
    if length(x) <> 4 then
      result := 0
    else
    begin
      try
        result := strtoint(x);
      except
        result := 0;
      end;
    end;
  end;

  function Jubel(Today, Origin: integer): boolean;
  begin
    if Origin = 0 then
    begin
      result := false;
      diff := 0;
      exit;
    end;
    diff := Today - Origin;
    if diff >= 25 then
    begin
      result := (diff mod 25) = 0;
    end else
    begin
      result := false;
    end;
  end;

begin
 // ImportAndCreate;
  if length(edit1.Text) > 1 then
  begin
    screen.cursor := crHourGlass;
    ToFind := AnsiUpperCase(edit1.text);
    if ToFind[1] in ['0'..'9'] then
    begin
   // suche nach JahresZahl
      if (length(ToFind) = 4) then
      begin
        j := strtoint(ToFind);
        Actinfos := -1;
        ListBox1.items.BeginUpdate;
        ListBox1.Items.clear;
        for n := 0 to pred(AllData.Count) do
        begin
          InpStr := AllData[n];
          NameStr := nextp;
          g := ToNumber(nextp);
          s := ToNumber(nextp);
          if jubel(j, g) then
            listbox1.Items.add(NameStr + ': ' + inttostr(diff) + '. ' + LanguageStr[pred(141)]);
          if jubel(j, s) then
            listbox1.Items.add(NameStr + ': ' + inttostr(diff) + '. ' + LanguageStr[pred(140)]);
        end;
        ListBox1.items.EndUpdate;

      end;
    end else
    begin
   // suche nach namen
      Actinfos := -1;
      ListBox1.items.BeginUpdate;
      ListBox1.Items.clear;
      for n := 0 to pred(AllData.Count) do
      begin
        if (pos(ToFind, AllUp[n]) > 0) then
        begin
          InpStr := AllData[n];
          ListBox1.items.add(Nextp);
        end;
      end;
      ListBox1.items.EndUpdate;
    end;
    screen.cursor := crdefault;
  end else
  begin
    SelectAll;
  end;
end;

procedure TJubiForm.ImportAndCreate;
var
  AllF: TStringList;
  SinglF: TStringList;
  OutF: TStringList;

  name, geb, sterb, txt: string;
  FileNo: integer;
  ActLin: integer;
  AddInfo: boolean;

  function NextLeof: boolean;
  begin
    inc(ActLin);
    result := (ActLin >= SinglF.count);
  end;

  function CheckDate(d: string): string;
  var
    ok: boolean;
    n: integer;
  begin
    ok := true;
    for n := 1 to length(d) do
      if not (d[n] in ['0'..'9']) then
      begin
        ok := false;
        break;
      end;
    if ok then
      result := d
    else
      result := '';
  end;

begin
  AllF := TStringList.create;
  SinglF := TStringList.create;
  OutF := TStringList.create;

  dir('G:\delphi\Hebu\Pool\autoren\*.txt', AllF);
  AllF.sort;

  for FileNo := 0 to pred(AllF.count) do
  begin
    SinglF.LoadFromFile('G:\delphi\Hebu\Pool\autoren\' + AllF[FileNo]);

    ActLin := 0;

    if pos('Name:', SinglF[ActLin]) = 1 then
      name := noblank(copy(SinglF[ActLin], 6, MaxInt))
    else
      ShowMessage(AllF[FileNo] + ':' + SinglF[ActLin]);

    geb := '';
    sterb := '';
    txt := '';
    AddInfo := false;

    while true do
    begin
      if NextLeof then
        break;
      if pos('*:', SinglF[ActLin]) = 1 then
        geb := noblank(copy(SinglF[ActLin], 3, MaxInt));
      if pos('Geb.:', SinglF[ActLin]) = 1 then
        geb := noblank(copy(SinglF[ActLin], 6, MaxInt));
      if pos('+:', SinglF[ActLin]) = 1 then
        sterb := noblank(copy(SinglF[ActLin], 3, MaxInt));

      if AddInfo then
      begin
        if pos('{', SinglF[ActLin]) = 1 then
          break;
        txt := txt + SinglF[ActLin] + '#da';
      end else
      begin
        if pos('{', SinglF[ActLin]) = 1 then
          AddInfo := true;
      end;

    end;


    if (name <> '') then
      OutF.add(name + ';' + CheckDate(copy(geb, 1, 4)) + ';' + CheckDate(copy(sterb, 1, 4)) + ';' + txt);

  end;

 // name

  OutF.sort;
  OutF.SaveTofile('G:\hebucdr\system\autoren.txt');
  AllF.free;
  SinglF.free;
  OutF.free;
  hide;
end;

procedure TJubiForm.FormCreate(Sender: TObject);
begin
  AllData := TstringList.create;
  AllUp := TstringList.create;
  Actinfos := -1;
end;

procedure TJubiForm.LoadInfosFor(index: integer);
begin
  if (index = ActInfos) then
    exit;
  SetInfo;
  ActInfos := index;
end;

procedure TJubiForm.Loadall;
begin
  if FileExists(SystemPath + '\autoren.txt') then
    AllData.LoadFromFile(SystemPath + '\autoren.txt');
end;

procedure TJubiForm.SelectAll;
var
  n: integer;
  nameStr: string;
begin
  screen.cursor := crHourGlass;
  AllUp.clear;
  Actinfos := -1;
  ListBox1.items.BeginUpdate;
  ListBox1.Items.clear;
  for n := 0 to pred(AllData.Count) do
  begin
    InpStr := AllData[n];
    nameStr := Nextp;
    ListBox1.items.add(nameStr);
    AllUp.add(ansiuppercase(nameStr));
  end;
  ListBox1.items.EndUpdate;
  screen.cursor := crdefault;
end;

procedure TJubiForm.SetInfo;
var
  n, m: integer;
  k: integer;

begin
  if listbox1.itemindex <> -1 then
  begin
    InpStr := listbox1.items[listbox1.itemindex];
    k := pos(':', inpStr);
    if (k > 0) then
      InpStr := copy(InpStr, 1, pred(k));
    for n := 0 to pred(AllData.Count) do
      if pos(inpStr, AllData[n]) = 1 then
      begin
        memo1.Lines.clear;
        InpStr := AllData[n];
        Nextp;
        memo1.Lines.add(Nextp + '-' + Nextp);
        repeat
          m := pos('#da', InpStr);
          if m > 0 then
          begin
            memo1.Lines.add(copy(InpStr, 1, pred(m)));
            InpStr := copy(InpStr, m + 3, MaxInt);
          end else
          begin
            memo1.Lines.add(InpStr); // Tmemo


      //
      // imp pend, set postion to TOP
      //
            break;
          end;
        until (InpStr = '');
      end;
    Memo1.SetFocus;
    Memo1.SelStart := 0;
    Memo1.SelLength := 0;
    listbox1.SetFocus;
   {
   memo1.perform(WM_KEYDOWN,17,1);
   memo1.perform(WM_KEYDOWN,vk_home,1);
   memo1.perform(WM_KEYUP,vk_home,1);
   memo1.perform(WM_KEYUP,17,1);
   }

//  paraml  := vk_f1 + pred(k) + ((59 + pred(k)) shl 16);

  end;
end;

procedure TJubiForm.FormActivate(Sender: TObject);
begin
  if not (Initialized) then
  begin
    Initialized := true;
    screen.cursor := crHourGlass;
    caption := LanguageStr[pred(138)];
    label1.caption := LanguageStr[pred(139)];
    Loadall;
    SelectAll;
    screen.cursor := crdefault;
  end;
end;

procedure TJubiForm.Timer1Timer(Sender: TObject);
begin
  if active and initialized then
  begin
    if (listbox1.itemindex <> -1) then
      LoadInfosFor(listbox1.itemindex)
    else
      memo1.Clear;
  end;
end;

function TJubiForm.NextP: string;
var
  k: integer;
begin
  k := pos(';', inpStr);
  if (k = 0) then
  begin
    result := InpStr;
    InpStr := '';
  end else
  begin
    result := copy(InpStr, 1, pred(k));
    InpStr := copy(inpStr, succ(k), MaxInt);
  end;
end;

procedure TJubiForm.ListBox1DblClick(Sender: TObject);
var
  SearchStr: string;
  k: integer;
begin
  if (listbox1.itemindex <> -1) then
  begin
    SearchStr := listbox1.Items[listbox1.itemindex];
    k := pos(',', SearchStr);
    if (k > 0) then
      SearchStr := copy(SearchStr, 1, pred(k));
    k := pos(':', SearchStr);
    if k > 0 then
      SearchStr := copy(SearchStr, 1, pred(k));
    k := pos('-', SearchStr);
    if k > 0 then
      SearchStr := copy(SearchStr, 1, pred(k));
    hide;
    FormHeBuBase.InpStr := AnsiUpperCase(SearchStr);
    FormHeBuBase.SetFeldFilterAutor;
    FormHeBuBase.DoSearch;
    if FormHeBuBase.FoundAnz = 0 then
    begin
      FormHeBuBase.InpStr := AnsiUpperCase(SearchStr);
      FormHeBuBase.UnSetFeldFilterAutor;
      FormHeBuBase.DoSearch;
    end;
  end;
end;

procedure TJubiForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  timer1.Enabled := false;
end;

procedure TJubiForm.MakeAbfrage;
var
  NixFind: TStringList;
  WasFind: TStringList;
  SearchStr: string;
  n, k: integer;
begin
  hide;
  NixFind := TStringList.create;
  WasFind := TStringList.create;
  for n := 0 to pred(AllData.count) do
  begin
    application.processmessages;
    SearchStr := listbox1.Items[n];
    k := pos(',', SearchStr);
    if (k > 0) then
      SearchStr := copy(SearchStr, 1, pred(k));
    k := pos(':', SearchStr);
    if k > 0 then
      SearchStr := copy(SearchStr, 1, pred(k));
    FormHeBuBase.InpStr := SearchStr;
    FormHeBuBase.SetFeldFilterAutor;
    FormHeBuBase.DoSearch;
    if FormHeBuBase.FoundAnz = 0 then
      NixFind.add(AllData[n])
    else
      WasFind.add(AllData[n]);
  end;
  NixFind.SaveToFile('G:\delphi\hebu\berichte\autoren nixgefunden.txt');
  NixFind.free;
  WasFind.SaveToFile('G:\delphi\hebu\berichte\autoren gefunden.txt');
  WasFind.free;
  ShowMEssage('Fertig!');
end;

procedure TJubiForm.Button1Click(Sender: TObject);
begin
  DoSearch;
end;

procedure TJubiForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;

end;

end.
