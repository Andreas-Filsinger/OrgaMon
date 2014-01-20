unit Willkommen;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Spin, ExtCtrls, ComCtrls,
  Grids, WordIndex, ImgList,
  Menus;

type
  TWillkommenForm = class(TForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Panel3: TPanel;
    ComboBox2: TComboBox;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    Edit6: TEdit;
    Panel8: TPanel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ListBox1: TListBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Edit8: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel10: TPanel;
    Edit9: TEdit;
    Edit10: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    MonthCalendar1: TMonthCalendar;
    Edit5: TEdit;
    Label20: TLabel;
    Panel13: TPanel;
    Button3: TButton;
    StringGrid2: TStringGrid;
    Panel14: TPanel;
    Panel15: TPanel;
    ComboBox5: TComboBox;
    Label24: TLabel;
    Label25: TLabel;
    Panel16: TPanel;
    Image2: TImage;
    CheckBox4: TCheckBox;
    Label19: TLabel;
    Label23: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    Panel4: TPanel;
    Panel5: TPanel;
    SpinEdit1: TSpinEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    CheckBox5: TCheckBox;
    Panel18: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Edit7: TEdit;
    Image7: TImage;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    ListView1: TListView;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    lschen1: TMenuItem;
    ndern1: TMenuItem;
    Image8: TImage;
    Edit11: TEdit;
    Label35: TLabel;
    Edit2: TEdit;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox3KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9Exit(Sender: TObject);
    procedure ComboBox4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure MonthCalendar1Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure StringGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox4Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Exit(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit7Change(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: Char);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure Edit11KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);
    procedure Edit9Enter(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }// TEdit
  public
    { Public-Deklarationen }

    // invisible Data
    _PforteEin: byte;
    _PforteAus: byte;
    _PfoertnerEin: string;
    _PfoertnerAus: string;

    BesucherL: TStringList; // such-Worte mit Index-Zahlen
    BesucherSuche: TWordIndex; // Wortsuche
    BesucherColumns: TList; // Einzelne Spalten
    NichtGefunden: TStringList;
    MitarbeiterL: TStringList;
    MitarbeiterSuche: TWordIndex;
    Unterschrift: TBitMap;
    ExecuteEditBesucherChanges: boolean;
    ExecuteEditMitarbeiterChanges: boolean;
    BMPChanged: boolean;
    DoNotSearch: boolean;

    BesucherLoeschen: TStringList; // FileAge
    BesucherLoeschenChanged: boolean;
    BesucherLoeschenLoaded: boolean;

    BesucherErwartet: TStringList; //
    BesucherErwartetRefreshPlease: boolean;
    PreSelektedBesucher: integer;

    procedure BesucherSucheChange(Sender: TObject);
    procedure MitarbeiterSucheChange(Sender: TObject);
    procedure InsertBesucherData(NextEdit: TWinControl);
    procedure InsertMitarbeiterData(SelectedRow: integer);
    procedure LoadUnterschriftBMP(MyBMP: TBitMap);
    procedure BerechneNeueBesuchsDauer;
    procedure ReBuildFahrzeugAbility;
    function SelectionData: TStringList;
    procedure SetMuelleimer;
    procedure BesucherErwartetRefresh;
    procedure ClearReferenzUnterschrift;
    procedure SaveUnterschriftAs(FName: string);
    procedure SaveGeloeschteBesucher;
  end;

var
  WillkommenForm: TWillkommenForm;

implementation

uses
  BesucherListe, math, anfix32, wanfix32,
  globals, VerbindungIT, splash;

{$R *.DFM}

procedure TWillkommenForm.FormCreate(Sender: TObject);
var
  n: integer;
  MyColums: TStringList;
  OneLineStr: string;

  function NextP: string;
  var
    k: integer;
  begin
    k := pos(';', OneLineStr);
    if (k > 0) then
    begin
      result := copy(OneLineStr, 1, pred(k));
      delete(OneLineStr, 1, k);
    end else
    begin
      result := OneLineStr;
      OneLineStr := '';
    end;
  end;

begin
  color := clblack;
  GroupBox1.top := 1;
  GroupBox1.Left := 1;
  width := GroupBox1.width + 2;
  height := GroupBox1.height + 2;
  BesucherColumns := TList.create;
  BesucherLoeschen := TStringList.create;
  BesucherErwartet := TStringList.create;

  SplashWrite('Besucher .');
  NichtGefunden := TStringList.create;
  NichtGefunden.add('<nicht gefunden>');
  NichtGefunden.add('-');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');

  BesucherL := TStringList.create;
  if FileExists(MyProgramPath + cBesucherFName) then
    BesucherL.LoadFromFile(MyProgramPath + cBesucherFName);

  SplashWrite('Besucher ...');

  for n := 0 to pred(BesucherL.count) do
  begin
    OneLineStr := BesucherL[n];

    MyColums := TStringList.Create;
    MyColums.addobject(NextP, TObject(n)); // {01} Name
    MyColums.add(NextP); // {02} firma
    MyColums.add(NextP); // {03} kfz
    MyColums.add(NextP); // {04} handy
    MyColums.add(NextP); // {05} bemerkung
    MyColums.add(NextP); // {06} Letzer Besuchsgrund
    MyColums.add(NextP); // {07} Anrede
    MyColums.add(NextP); // {08} Datum letzter Besuch, letze Datensatzänderung
    MyColums.add(NextP); // {09} erste Besuchs-TAN = BesucherID
    MyColums.add(NextP); // {10} bevorzugtes Ziel
    MyColums.add(NextP); // {11} Nation
    MyColums.add(NextP); // {12} Symbol

    BesucherL.Objects[n] := TObject(n);
    BesucherL[n] := MyColums[0] + ' ' + MyColums[1] + ' ' + MyColums[2];
    BesucherColumns.add(MyColums);

  end;

  if (FileAge(MyProgramPath + 'Besucher.idx') >= FileAge(MyProgramPath + 'Besucher.txt')) and
    (BesucherL.count > 0) then
  begin
    BesucherSuche := TWordIndex.create(nil);
    BesucherSuche.LoadFromFile(MyProgramPath + 'Besucher.idx');
  end else
  begin
    BesucherSuche := TWordIndex.create(BesucherL, 1);
  end;

 // Mitarbeiter
  SplashWrite('Mitarbeiter ...');
  MitarbeiterL := TStringList.create;
  if FileExists(MyProgramPath + 'Mitarbeiter.txt') then
    MitarbeiterL.LoadFromFile(MyProgramPath + 'Mitarbeiter.txt');
  with stringgrid2 do // TstringGrid
  begin
    DefaultRowHeight := canvas.TextHeight('X') + 3;
    rowCount := succ(MitarbeiterL.count);
    cells[0, 0] := 'Mitarbeiter'; ColWidths[0] := canvas.TextWidth(cells[0, 0]) + 112;
    cells[1, 0] := 'Gebäude'; ColWidths[1] := canvas.TextWidth(cells[1, 0]) + 39;
    cells[2, 0] := 'Durchwahl'; ColWidths[2] := canvas.TextWidth(cells[2, 0]) + 36;
    for n := 0 to pred(MitarbeiterL.count) do
    begin
      OneLineStr := MitArbeiterL[n];
      MyColums := TStringList.Create;
      MyColums.add(NextP); // name
      MyColums.add(NextP); // Gebäude
      MyColums.add(NextP); // Telefon-Nummer
      MitArbeiterL.Objects[n] := MyColums;
      MitarbeiterL[n] := MyColums[0]; // suche nur nach Name
      Rows[succ(n)] := TStrings(MitarbeiterL.objects[n]);
    end;
  end;
  MitarbeiterSuche := TWordIndex.create(MitarbeiterL, 1);

  ExecuteEditBesucherChanges := true;
  ExecuteEditMitarbeiterChanges := true;
  Unterschrift := TBitMap.Create;
  Unterschrift.Monochrome := true;

 // Bilder laden
  image1.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('P21'));
  image3.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('P51'));
  image4.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('P61'));
  image5.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('P71'));
  image6.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('P81'));
end;

procedure TWillkommenForm.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    if (Edit4.Text <> '') then
    begin
      InsertMitarbeiterData(StringGrid2.row);
    end else
    begin
      if button1.enabled then
        button1.Setfocus
      else
        button2.Setfocus;
    end;
    Key := #0;
  end;
end;

procedure TWillkommenForm.Button2Click(Sender: TObject);
begin
  Button1.Enabled := true;
  close;
end;

procedure TWillkommenForm.FormActivate(Sender: TObject);
var
  n: integer;
  _PreSelektedBesucher: string;
  BesucherData: TStringList;
  FoundPreSelected: boolean;
begin
  BesucherErwartetRefreshPlease := true;
  if not (BesucherLoeschenLoaded) then
  begin
    BesucherLoeschen.sorted := false;
    if FileExists(BesucherLoeschenFName) then
      BesucherLoeschen.LoadFromFile(BesucherLoeschenFName);
    BesucherLoeschen.sorted := true;
    BesucherLoeschenLoaded := true;
  end;

  button3.visible := (VerbindungITForm.idTCPCLient1.connected);
  checkbox4.visible := (VerbindungITForm.idTCPCLient1.connected);

  checkbox4.checked := (label18.Caption = '0');

  if (ListBox1.items.count > 0) then
    Listbox1.ItemIndex := pred(ListBox1.items.count);

  if (ComboBox4.Items.count = 0) then
    if FileExists(MyProgramPath + 'Besuchsgründe.ini') then
      Combobox4.Items.LoadFromFile(MyProgramPath + 'Besuchsgründe.ini');

  if (ComboBox5.Items.count = 0) then
    if FileExists(MyProgramPath + 'Mitgebrachtes.ini') then
      Combobox5.Items.LoadFromFile(MyProgramPath + 'Mitgebrachtes.ini');

  while true do
  begin
    if (_PforteEin = 0) and (_PforteAus = 0) then
    begin
   // Planung
      GroupBox1.Color := $88BFF7;
      GroupBox1.Caption := 'geplanter Besuch ...';
      edit9.enabled := true;
      MonthCalendar1.Visible := true;
      break;
    end;

    if (_PforteEin <> 0) and (_PforteAus <> 0) then
    begin
      GroupBox1.Color := $D2D2D2;
      GroupBox1.Caption := 'Besuchshistorie ...';
      edit9.enabled := true;
      MonthCalendar1.Visible := true;
      break;
    end;

    GroupBox1.Color := $C1DF8E;
    GroupBox1.Caption := 'herzlich Willkommen ...';
    edit9.enabled := true;
    MonthCalendar1.Visible := false;
    break;
  end;

  if PreSelektedBesucher <> 0 then
  begin
    FoundPreSelected := false;
    _PreSelektedBesucher := inttostr(PreSelektedBesucher);
    for n := 0 to pred(BesucherColumns.count) do
    begin
      BesucherData := TStringList(BesucherColumns[n]);
      if _PreSelektedBesucher = BesucherData[8] then
      begin
        // jetzt wie Enter-Drücken!
        with ListView1.items.Add do
        begin
          ImageIndex := 6;
          data := BesucherData;
          caption := BesucherData[0];
          subitems.add(BesucherData[1]);
          subitems.add(BesucherData[2]);
          subitems.add(BesucherData[3]);
        end;
        ListView1.selected := ListView1.items[0];
        InsertBesucherData(edit6);
        FoundPreSelected := true;

        break;
      end;
    end;
    PreSelektedBesucher := 0;
    if not (FoundPreSelected) then
      ShowMessage('Die Besuchs-TAN [' + _PreSelektedBesucher + '] ist unbekannt!' + #13 +
                  'Stammt die Nummer von einem gateF-Ausdruck liegt ein' + #13 +
                  'Verarbeitungsfehler im Bereich Besucher vor!' + #13 +
                  'Notieren Sie sich die Nummer (ggf. Bildschirmausdruck)' + #13 +
                  'und melden Sie die Störung.');
  end;
end;

procedure TWillkommenForm.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  _ItemIndex: integer;
  k: integer;
  n: integer;
begin
  if (Key = VK_DELETE) then
    if (ListBox1.ItemIndex <> -1) then
    begin
      _ItemIndex := ListBox1.ItemIndex;
      Listbox1.Items.Delete(Listbox1.ItemIndex);
      if (ListBox1.items.count = 0) then
      begin
        edit4.SetFocus;
      end else
      begin
        ListBox1.ItemIndex := min(pred(ListBox1.items.count), _ItemIndex);
      end;
    end;
  if (Key = VK_INSERT) then
    edit4.SetFocus;

  if (Key = ord('1')) and (listbox1.itemindex <> -1) and (listbox1.items.count > 0) then
  begin
  // setzen, ausschalten
    k := pos('!', Listbox1.items[listbox1.itemindex]);
    if k = 0 then
      Listbox1.items[listbox1.itemindex] := Listbox1.items[listbox1.itemindex] + '!'
    else
      Listbox1.items[listbox1.itemindex] := copy(Listbox1.items[listbox1.itemindex], 1, pred(k)) +
        copy(Listbox1.items[listbox1.itemindex], succ(k), MaxInt);

  // bei allen anderen auf alle Fälle ausschalten
    for n := 0 to pred(Listbox1.items.count) do
    begin
      if n = Listbox1.itemindex then
        continue;
      k := pos('!', Listbox1.items[n]);
      if k > 0 then
        Listbox1.items[n] := copy(Listbox1.items[n], 1, pred(k)) +
          copy(Listbox1.items[n], succ(k), MaxInt);

    end;

  end;

end;

procedure TWillkommenForm.BerechneNeueBesuchsDauer;
var
  NumStr: string;
  _InpStr: string;
  n: integer;
  EndTime: TAnfixTime;
  NewDuration: TAnfixTime;
begin
  if length(ComboBox3.Text) > 0 then
  begin
    _InpStr := ComboBox3.Text;

    if pos('Tag', _InpStr) > 0 then
      _InpStr := secondstostr5(strtoseconds('18:00') - strtoseconds(edit10.Text));

    NewDuration := 0;
    if pos(':', _InpStr) > 0 then
    begin
      NewDuration := strtoseconds(_inpStr);
    end else
    begin

      NumStr := '';
      for n := 1 to length(ComboBox3.Text) do
        if _inpStr[n] in ['0'..'9'] then
          NumStr := NumStr + _inpStr[n];

      while true do
      begin


        if (pos('h', _InpStr) > 0) then
        begin
     // ganze Stunden
          NewDuration := StrToSeconds(NumStr + ':00');
          break;
        end;

        if (pos('m', _InpStr) > 0) then
        begin
     // Minuten
          NewDuration := strtoseconds('00:' + NumStr);
          break;
        end;

        if (length(NumStr) = 1) or (pos('h', _InpStr) > 0) then
        begin
     // ganze Stunden
          NewDuration := StrToSeconds('0' + NumStr + ':00');
          break;
        end;

        if (length(NumStr) = 2) or (pos('m', _InpStr) > 0) then
        begin
     // Minuten
          NewDuration := strtoseconds('00:' + NumStr);
          break;
        end;

        break;
      end;
    end;

    EndTime := strtoseconds(edit10.Text) + NewDuration;
    if (EndTime > 24 * 60 * 60) then
    begin
      EndTime := EndTime - 24 * 60 * 60;
      label35.caption := long2date(DatePlus(date2long(edit9.Text), 1));
   // imp pend: set end date to next day
   // use SecondsAddLong(d1,s1,Plus : longint; var d2,s2 : longint);
    end else
    begin
      label35.caption := edit9.Text;
    end;
    Label17.caption := secondstostr5(EndTime);
  end;
end;

procedure TWillkommenForm.ComboBox3KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    edit4.SetFocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Button1Click(Sender: TObject);
begin
 // this is OK
  BesucherListeForm.WillkommenOK;
end;

procedure TWillkommenForm.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
  begin
    Edit3.SetFocus;
    Key := #0;
  end;
end;

procedure TWillkommenForm.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    if (Edit3.Text <> '') then
    begin
      InsertBesucherData(edit6);
    end else
    begin
      Edit6.Setfocus;
    end;
    Key := #0;
  end;
end;

procedure TWillkommenForm.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Edit8.Setfocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Edit8KeyPress(Sender: TObject; var Key: Char);
begin

  if key = #13 then
  begin
    if (Edit8.Text <> '') then
    begin
      InsertBesucherData(edit5);
    end else
    begin
      Edit5.Setfocus;
    end;
    Key := #0;
  end;

  if key in ['a'..'z'] then
    key := AnsiUpperCase(key)[1];

  if (key = ' ') and (pos('-', edit8.Text) = 0) then
    Key := '-';
end;

procedure TWillkommenForm.Edit9Exit(Sender: TObject);
begin
  label35.caption := Edit9.Text;
end;

procedure TWillkommenForm.ComboBox4KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    Edit11.Setfocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    Edit10.SetFocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.MonthCalendar1Click(Sender: TObject);
begin
  edit9.Text := long2date(DateTime2long(MonthCalendar1.date));
  label35.caption := edit9.Text;
end;

procedure TWillkommenForm.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if ComboBox4.enabled then
      ComboBox4.SetFocus
    else
      edit11.SetFocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Edit1.Setfocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    ComboBox1.Setfocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.Button3Click(Sender: TObject);
begin
  if (VerbindungITForm.edit2.Text<>'') then
  begin
   edit3.Text := VerbindungITForm.edit2.Text; // Name
   edit1.Text := VerbindungITForm.label4.caption; // Sprache
  end;
  if (VerbindungITForm.edit3.Text<>'') then
   edit6.Text := VerbindungITForm.edit3.Text; // Firma
  if (VerbindungITForm.edit4.Text<>'') then
   edit5.Text := VerbindungITForm.edit4.Text; // Handy
  LoadUnterschriftBMP(VerbindungITForm.Image1.Picture.Bitmap);
end;

procedure TWillkommenForm.BesucherSucheChange(Sender: TObject);
var
  n, k: integer;
  SearchStr: string;
  NewItem: TListItem;
  InfoList: TStringList;
  TimeOutS: dword;
begin
  if not (DoNotSearch) then
  begin
    TimeOutS := GetTickCount;
    SearchStr := cutblank(Edit3.Text + ' ' + Edit6.Text + ' ' + ansiuppercase(edit8.Text));
    if (length(SearchStr) > 1) then
    begin
      with BesucherSuche do
      begin
        Search(SearchStr);
        if (FoundList.count = 0) then
        begin
          ListView1.Items.clear; // TListView
        end else
        begin
          with ListView1 do
          begin
            AllocBy := FoundList.Count;
            Items.BeginUpdate;
            Items.clear; // TListView
            if BesucherErwartetRefreshPlease then
              BesucherErwartetRefresh;

            for n := 0 to pred(FoundList.Count) do
            begin
              InfoList := TStringList(BesucherColumns[integer(FoundList[n])]);
              with Items.add do
              begin
                data := InfoList;
                caption := InfoList[0];
                subitems.add(InfoList[1]);
                subitems.add(InfoList[2]);

        // Symbol noch festlegen
                k := BesucherErwartet.Indexof(InfoList[8]);

                if (k <> -1) then
                begin
                  ImageIndex := 8;
                  InfoList.Objects[0] := BesucherErwartet.objects[k];
                  with BesucherErwartet.objects[k] as TLineRec do
                  begin
                    case DateDiff(DateGet, sDatum) of
                      -1: subitems.add('gestern um ' + secondstostr5(sZeit));
                      0: subitems.add('heute um ' + secondstostr5(sZeit));
                      +1: subitems.add('morgen um ' + secondstostr5(sZeit));
                    else
                      subitems.add(long2date(sdatum) + ' um ' + secondstostr5(sZeit));
                    end;
                    if RepetierendBis <> 0 then
                      ImageIndex := 2;
                  end;
                end else
                begin
                  if (BesucherLoeschen.IndexOf(InfoList[8]) = -1) then
                    ImageIndex := -1
                  else
                    ImageIndex := 0;
                  subitems.add(InfoList[3]);
                end;
              end;
              if (n mod 6 = 0) then
                if frequently(TimeOuts, 800) then
                  break;
            end;
            if (Items.Count > 0) then
              ListView1.Selected := ListView1.Items[0];
            Items.EndUpdate;
          end;
        end;
      end;
    end else
    begin
      ListView1.Items.clear; // TListView
    end;
  end;
end;

procedure TWillkommenForm.MitarbeiterSucheChange(Sender: TObject);
var
  n: integer;
begin
  if not (DoNotSearch) then
  begin
    with stringgrid2 do // TstringGrid
    begin
      if length(Edit4.Text) > 1 then
      begin

        with MitarbeiterSuche do
        begin
          Search(Edit4.Text);
          if FoundList.count = 0 then
          begin
            RowCount := 2;
            Rows[1] := NichtGefunden;
          end else
          begin
            RowCount := succ(FoundList.Count);
            for n := 0 to pred(FoundList.Count) do
              Rows[succ(n)] := TStrings(FoundList[n]);
          end;
          Row := 1;
        end;

      end else
      begin
        rowCount := succ(MitarbeiterL.count);
        for n := 0 to pred(MitarbeiterL.count) do
          Rows[succ(n)] := TStrings(MitarbeiterL.objects[n]);
      end;
    end;
  end;
end;

procedure TWillkommenForm.Edit4Change(Sender: TObject);
begin
  if ExecuteEditMitarbeiterChanges then
    if pos('(', edit4.Text) = 0 then
      MitarbeiterSucheChange(Sender);
end;

procedure TWillkommenForm.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with stringgrid2 do
    case Key of
      VK_Down: begin
          if row < pred(RowCount) then
            row := row + 1
          else
            beep;
          Key := 0;
        end;
      VK_UP: begin
          if row > 1 then
            row := row - 1
          else
            beep;
          Key := 0;
        end;
    end;
end;

procedure TWillkommenForm.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with ListView1 do
    if items.count > 0 then
    begin
      case Key of
        VK_Down: begin
            if Selected <> items[pred(items.count)] then
              Selected := items[Selected.index + 1]
            else
              beep;
            Key := 0;
          end;
        VK_UP: begin
            if Selected <> items[0] then
              Selected := items[Selected.index - 1]
            else
              beep;
            Key := 0;
          end;
        VK_DELETE: begin
            if (edit3.SelStart = length(edit3.Text)) then
            begin
              SetMuelleimer;
              Key := 0;
            end;
          end;
      end;
    end;
end;

procedure TWillkommenForm.Edit6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Edit3KeyDown(Sender, Key, Shift);
end;

procedure TWillkommenForm.Edit8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Edit3KeyDown(Sender, Key, Shift);
end;

procedure TWillkommenForm.Edit3Change(Sender: TObject);
begin
  if ExecuteEditBesucherChanges then
    BesucherSucheChange(Sender);
end;

procedure TWillkommenForm.Edit6Change(Sender: TObject);
begin
  if ExecuteEditBesucherChanges then
    BesucherSucheChange(Sender);
end;

procedure TWillkommenForm.Edit8Change(Sender: TObject);
begin
  if ExecuteEditBesucherChanges then
    BesucherSucheChange(Sender);
end;

procedure TWillkommenForm.Edit11KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    ComboBox3.Setfocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.InsertBesucherData(NextEdit: TWinControl);
var
  _BesuchsGrund: string;
  _Anrede: string;
  ResultList: TStringList;
  BmpFname: string;
begin
  if assigned(ListView1.Selected) then
    with ListView1.Selected do // TStringGrid
    begin
      ResultList := TStringList(data);


      if (ImageIndex = 8) or (ImageIndex = 2) then
        if doit('Der Besuch wird möglicherweise erwartet!' + #13 +
          'Soll der Planungseintrag angezeigt werden') then
        begin
          close;
          BesucherListeForm.BesuchJetztEingetroffen(TLineRec(ResultList.objects[0]));
          exit;
        end;

      ExecuteEditBesucherChanges := false;
      BmpFname := MyProgramPath + cAblagePath + ResultList[8] + '.bmp';
      if FileExists(BmpFname) then
      begin
        image8.Picture.LoadFromFile(BmpFname);
        BMPScramble(image8.picture.Bitmap, KeyFromFName(BMPFName));
        image8.picture.Assign(image8.picture.Bitmap);
      end else
        ClearReferenzUnterschrift;

      edit3.Text := ResultList[0];
      edit6.Text := ResultList[1];
      edit8.Text := ResultList[2];
      edit5.Text := ResultList[3];
      label30.caption := ResultList[8]; // Besucher-ID
      label33.caption := ResultList[7]; // datum
      Edit1.Text := ResultList[10]; // Nation
      _BesuchsGrund := ResultList[5];
      _Anrede := ResultList[6];
      edit4.text := ResultList[9];

      RadioButton1.Checked := false;
      RadioButton2.Checked := false;
      RadioButton3.Checked := false;
      RadioButton4.Checked := false;
      RadioButton5.Checked := false;
      if (ResultList[11] = '2') then
        RadioButton1.Checked := true;
      if (ResultList[11] = '5') then
        RadioButton2.Checked := true;
      if (ResultList[11] = '6') then
        RadioButton3.Checked := true;
      if (ResultList[11] = '7') then
        RadioButton4.Checked := true;
      if (ResultList[11] = '8') then
        RadioButton5.Checked := true;

      CheckBox5.Checked := (ResultList[5] = cAnlieferung);
      ExecuteEditBesucherChanges := true;

      if (_BesuchsGrund <> '') then
        if ComboBox4.Items.IndexOf(_BesuchsGrund) <> 0 then
          ComboBox4.Items.Insert(0, _BesuchsGrund);

      if (_Anrede <> '') then
        if (_Anrede = 'Herr') or (_Anrede = 'Frau') or (_Anrede = 'Gruppe') then
          ComboBox1.Text := _Anrede;

      if ComboBox4.enabled then
        ComboBox4.SetFocus
      else
        Edit11.SetFocus;
    end else
  begin
    NextEdit.Setfocus;
  end;
end;

procedure TWillkommenForm.InsertMitarbeiterData(SelectedRow: integer);
begin
  with stringgrid2 do // TStringGrid
  begin
    if (pos('<', Cells[0, SelectedRow]) <> 1) and (pos('!', edit4.TExt) = 0) then
      listbox1.items.add(Cells[0, SelectedRow] + ' (' + Cells[1, SelectedRow] + ' ' + Cells[2, SelectedRow] + ')')
    else
      listbox1.items.add(Edit4.Text);
  end;
  listbox1.ItemIndex := pred(ListBox1.Items.count);
  Edit4.Text := '';
  Edit4.SetFocus;
end;

procedure TWillkommenForm.StringGrid2DblClick(Sender: TObject);
begin
  InsertMitarbeiterData(StringGrid2.Row);
end;

procedure TWillkommenForm.StringGrid2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
  begin
    InsertMitarbeiterData(StringGrid2.Row);
    Key := #0;
  end;
end;

procedure TWillkommenForm.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
    VerbindungITForm.Load;
end;

procedure TWillkommenForm.LoadUnterschriftBMP(MyBMP: TBitMap);
begin

  // altes Bild löschen
  Unterschrift.free;
  Unterschrift := TBitMap.Create;
  Unterschrift.Monochrome := true;

  if assigned(MyBmp) then
  begin
    // erst mal dauerhaft wegspeichern!
    Unterschrift.height := MyBmp.Height;
    Unterschrift.Width := MyBmp.Width;
    Unterschrift.Canvas.Draw(0, 0, MyBMP);

    // nun dem Witzbild zuweisen
    BMPChanged := true;

    with image2.Picture.bitmap do // Timage
    begin
      height := Unterschrift.height div 2;
      width := Unterschrift.width div 2;
      canvas.StretchDraw(Rect(0, 0, Unterschrift.width div 2, Unterschrift.height div 2), Unterschrift);
    end;
  end else
  begin
    with image2.Picture.bitmap do // Timage
    begin
      height := 0;
      width := 0;
    end;
  end;
end;

procedure TWillkommenForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ';' then
    Key := #0;

end;

procedure TWillkommenForm.CheckBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    edit3.SetFocus;
  end;
end;

procedure TWillkommenForm.ComboBox3Exit(Sender: TObject);
begin
  BerechneNeueBesuchsDauer;
end;

procedure TWillkommenForm.CheckBox5Click(Sender: TObject);
begin
  ReBuildFahrzeugAbility;
end;

procedure TWillkommenForm.ReBuildFahrzeugAbility;
begin
  if CheckBox5.checked or CheckBox1.Checked then
  begin
    radiobutton1.Enabled := true;
    radiobutton2.Enabled := true;
    radiobutton3.Enabled := true;
    radiobutton4.Enabled := true;
    radiobutton5.Enabled := true;
  end else
  begin
    radiobutton1.Enabled := false;
    radiobutton2.Enabled := false;
    radiobutton3.Enabled := false;
    radiobutton4.Enabled := false;
    radiobutton5.Enabled := false;
  end;
  if CheckBox5.Checked then
  begin
    ComboBox4.Enabled := false;
    ComboBox4.Text := cAnlieferung;
  end else
  begin
    ComboBox4.Enabled := true;
  end;
end;

procedure TWillkommenForm.CheckBox1Click(Sender: TObject);
begin
  ReBuildFahrzeugAbility;
end;

procedure TWillkommenForm.Image1Click(Sender: TObject);
begin
  if RadioButton1.enabled then
    RadioButton1.checked := not (RadioButton1.checked);
end;

procedure TWillkommenForm.Image3Click(Sender: TObject);
begin
  if RadioButton2.enabled then
    RadioButton2.checked := not (RadioButton2.checked);
end;

procedure TWillkommenForm.Image4Click(Sender: TObject);
begin
  if RadioButton3.enabled then
    RadioButton3.checked := not (RadioButton3.checked);
end;

procedure TWillkommenForm.Image5Click(Sender: TObject);
begin
  if RadioButton4.enabled then
    RadioButton4.checked := not (RadioButton4.checked);
end;

procedure TWillkommenForm.Image6Click(Sender: TObject);
begin
  if RadioButton5.enabled then
    RadioButton5.checked := not (RadioButton5.checked);
end;

procedure TWillkommenForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F5) then
    Image1Click(Sender);
  if (Key = VK_F6) then
    Image3Click(Sender);
  if (Key = VK_F7) then
    Image4Click(Sender);
  if (Key = VK_F8) then
    Image5Click(Sender);
  if (Key = VK_F9) then
    Image6Click(Sender);

  if ssCtrl in Shift then
    if Key = ord('L') then
    begin
      SetMuelleimer;
      key := 0;
    end;
end;

procedure TWillkommenForm.Edit7Change(Sender: TObject);
var
  k: integer;
begin
  repeat

    if edit7.Text = '' then
    begin
      Image7.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('A1'));
      break;
    end;

    k := CharCount('!', edit7.Text);
    if (k >= 2) then
    begin
      Image7.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('A3'));
      break;
    end;

    if (k >= 1) then
    begin
      Image7.Picture.Bitmap.assign(BesucherListeForm.SymbolRohstoffe.Symbol('A2'));
      break;
    end;

  until true;
end;

procedure TWillkommenForm.ListView1DblClick(Sender: TObject);
begin
  InsertBesucherData(edit6);
end;

procedure TWillkommenForm.ListView1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    InsertBesucherData(edit6);
  end;
end;

procedure TWillkommenForm.SetMuelleimer;
var
  tan: string;
  k: integer;
  DeleteIt: boolean;
begin
  if assigned(ListView1.selected) then
  begin
    BesucherLoeschenChanged := true;
    tan := SelectionData.strings[8];
    k := BesucherLoeschen.IndexOf(tan);
    if (k = -1) then
    begin
      BesucherLoeschen.add(tan);
      DeleteIt := true;
    end else
    begin
      BesucherLoeschen.delete(k);
      DeleteIt := false;
    end;
    with ListView1.selected do
    begin
      if DeleteIt then
        imageindex := 0
      else
        imageindex := -1;
    end;
  end;
end;

procedure TWillkommenForm.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Delete) then
    SetMuelleimer;
end;

function TWillkommenForm.SelectionData: TStringList;
begin
  result := TStringList(ListView1.selected.data);
end;

procedure TWillkommenForm.FormDestroy(Sender: TObject);
var
  n: integer;
begin
  for n := 0 to pred(BesucherColumns.count) do
    TObject(BesucherColumns[n]).free;
  BesucherColumns.free;
  BesucherLoeschen.free;
  NichtGefunden.free;
  BesucherL.free;
  for n := 0 to pred(MitarbeiterL.count) do
    MitarbeiterL.objects[n].free;
  MitarbeiterL.free;
  MitarbeiterSuche.free;
  Unterschrift.free;
  BesucherSuche.free;
  BesucherErwartet.free;
end;

procedure TWillkommenForm.BesucherErwartetRefresh;
var
  n: integer;
begin
  BesucherErwartet.clear;
  BesucherErwartet.Duplicates := dupIgnore;
  BesucherErwartet.sorted := true; // ermöglichen, daß unproblematisch alles
                                  // zunächst zugelassen wird!
  for n := BesucherListeForm.FutureBorder to pred(BesucherListeForm.items.count) do
    BesucherErwartet.addobject(inttostr(BesucherListeForm.items[n].BesucherID), BesucherListeForm.items[n]);
(*
 BesucherErwartet.sorted := true; // hoffe, daß indexof dadurch schneller ist -> JA
                                  // durch sort; allein nicht, da es NICHT sorted
                                  // setzt! Jedoch ein setzen von sorted auf true
                                  // sortiert die Liste (und setzt sorted auf true)
                                  // dadurch wird "indexof" verdammt schnell!
 RemoveDuplicates(BesucherErwartet); // sorted bleibt von delete unberührt!
*)
  BesucherErwartetRefreshPlease := false;
end;

procedure TWillkommenForm.ClearReferenzUnterschrift;
begin
  image8.Picture.Assign(nil);
end;

procedure TWillkommenForm.SaveUnterschriftAs(FName: string);

  procedure SaveIt;
  begin
    BMPScramble(Unterschrift, KeyFromFName(FName));
    Unterschrift.SaveToFile(FName);
  end;

begin
  if checkbox4.Checked then
    if (iBesucherTerminalIP <> '') then
      if (Unterschrift.width > 1) then
      begin
        if FileExists(FName) then
        begin
          if doit('Eine Referenz-Unterschrift ist vorhanden!' + #13 +
            'Soll die neue Unterschrift als Referenz gespeichert werden') then
            SaveIt;
        end else
        begin
          SaveIt;
        end;
      end;
end;

procedure TWillkommenForm.ComboBox5Change(Sender: TObject);
begin
  if Edit11.Text = '' then
    edit11.Text := ComboBox5.Text
  else
    edit11.Text := edit11.Text + ', ' + ComboBox5.Text;
  edit11.SetFocus;
end;

procedure TWillkommenForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    edit2.Text := cutblank(long2date(date2long(edit2.Text)));
    ComboBox3.SetFocus;
    key := #0;
  end;
end;

procedure TWillkommenForm.SaveGeloeschteBesucher;
begin
  if BesucherLoeschenChanged then
  begin
    if (BesucherLoeschen.count > 0) then
      BesucherLoeschen.SaveToFile(BesucherLoeschenFName)
    else
      FileDelete(BesucherLoeschenFName);
    BesucherLoeschenChanged := false;
  end;
end;

procedure TWillkommenForm.FormDeactivate(Sender: TObject);
begin
  SaveGeloeschteBesucher;
end;

procedure TWillkommenForm.Edit9Enter(Sender: TObject);
begin
  MonthCalendar1.Visible := true;
end;

procedure TWillkommenForm.Button4Click(Sender: TObject);
begin
  edit2.Text := long2date(DatePlus(BesucherListeForm.GetPfortenDate, -1));
end;

end.

