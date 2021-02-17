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
unit PEM;

{ Protokoll Editor Manager }

interface

uses
  SysUtils, classes, html;

function pem_FromFile(InpFName: string): string;
procedure pem_toText(sData: string; TemplateFName, OutFName: string);
procedure pem_FullList(InpMask: string; TheList: TStringList);
function pem_show(ProtokollName: string; Protokoll: TStringList): TStringList;
function pem_toHTML(VorlageName, ProtokollName: string;
  Protokoll: TStringList): THTMLTemplate;

implementation

uses
  anfix;

const
  cProtokollTrenner = 'ı';
  cProtokollVarStart = '$';
  cProtokollStop = '³';

  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    Parameter Read / Write
    Protocol Editor Management
    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

const
  c_pem_delimiter = ';';
  c_pem_assign = '=';
  c_pem_start = cProtokollVarStart;
  c_pem_start2 = cProtokollTrenner;
  c_pem_start3 = 'ü';

var
  c_pem_window_xl: integer;

procedure pem_toText(sData: string; TemplateFName, OutFName: string);
var
  Inf, OutF: text;
  InpStr: string;
  VarName: string[2];
  k, klen: integer;
  d, dlen: integer;
  pData: string;
begin
  assign(Inf, TemplateFName);
  reset(Inf);
  assign(OutF, OutFName);
  rewrite(OutF);
  c_pem_window_xl := -1;
  while not(eof(Inf)) do
  begin
    readln(Inf, InpStr);
    if c_pem_window_xl < 1 then
      c_pem_window_xl := pos(cProtokollStop, InpStr);
    if c_pem_window_xl <> -1 then
      repeat

        { Startposition bestimmen }
        k := pos(c_pem_start, InpStr);
        if k = 0 then
          break;
        InpStr[k] := c_pem_start2;

        { Parameter L„nge bestimmen }
        { Bug: ist die l„nge>c_pem_window_xl dann berschreiben die }
        { blanks den c_pem_start! }
        klen := pos(c_pem_start, InpStr);
        if klen = 0 then
          klen := 1
        else
        begin
          InpStr[klen] := c_pem_start2;
          klen := (klen - k);
        end;

        { Daten bestimmen und einsetzen }
        VarName := copy(InpStr, k + 1, 2);
        d := pos(VarName + c_pem_assign, sData);
        if d > 0 then
        begin
          dlen := pred(pos(c_pem_delimiter, copy(sData + c_pem_delimiter,
                d + 3, MaxInt)));
          pData := copy(sData, d + 3, dlen);
          bfill(pData, klen);
          InpStr := { prefix } copy(InpStr, 1, pred(k - c_pem_window_xl)) +
          { data } pData +
          { postfix } copy(InpStr, k - c_pem_window_xl + klen, MaxInt);
        end;

      until false;
      writeln(OutF, InpStr);
  end;
  Close(OutF);
  Close(Inf);
end;

function pem_FromFile(InpFName: string): string;
var
  InpF: text;
  InpStr: string;
  k, klen: integer;
  pData: string;
  VarName: string[2];
begin
  c_pem_window_xl := -1;
  result := '';
  assign(InpF, InpFName);
  reset(InpF);
  while not(eof(InpF)) do
  begin

    readln(InpF, InpStr);
    if (c_pem_window_xl < 1) then
      c_pem_window_xl := pos(cProtokollStop, InpStr);

    repeat

      { Startposition bestimmen }
      k := pos(c_pem_start2, InpStr);
      if (k = 0) then
        break;
      InpStr[k] := c_pem_start3;

      { Parameter L„nge bestimmen }
      klen := pos(c_pem_start2, InpStr);
      if (klen = 0) then
      begin
        { Ist nur einstelliger Parameter ohne Endeangabe }
        klen := 1;
      end
      else
      begin
        InpStr[klen] := c_pem_start3;
        klen := (klen - k) + 1;
      end;

      { Daten bestimmen und einsetzen }
      VarName := copy(InpStr, k + 1, 2);
      pData := cutblank(copy(InpStr, k - c_pem_window_xl, klen));
      if (length(pData) > 0) then
        result := result + VarName + c_pem_assign + pData + c_pem_delimiter;

    until false;

  end;
  Close(InpF);
end;

procedure pem_FullList(InpMask: string; TheList: TStringList);
var
  TheFiles: TStringList;
  TheProtokoll: TStringList;
  ThePath: string;
  n, m, k: integer;
  InpStr: string;
begin
  TheFiles := TStringList.create;
  TheProtokoll := TStringList.create;
  Dir(InpMask, TheFiles, false);
  ThePath := ExtractFilePath(InpMask);
  for n := 0 to pred(TheFiles.count) do
  begin
    TheProtokoll.LoadFromFile(ThePath + TheFiles[n]);
    for m := 0 to pred(TheProtokoll.count) do
    begin
      k := pos(cProtokollStop, TheProtokoll[m]);
      if k > 0 then
      begin
        InpStr := copy(TheProtokoll[m], succ(k), MaxInt);
        k := pos(cProtokollVarStart, InpStr);
        if (k > 0) then
          TheList.add(copy(InpStr, succ(k), 2));
      end;
    end;
  end;
  TheList.sort;
  removeduplicates(TheList);
  for n := 0 to pred(TheFiles.count) do
    TheList.insert(0, ' // ' + TheFiles[n] + ' vom ' + long2date
        (FileDate(ThePath + TheFiles[n])) + ' ' + secondstostr
        (FileSeconds(ThePath + TheFiles[n])));
  TheFiles.free;
  TheProtokoll.free;
end;

function pem_show(ProtokollName: string; Protokoll: TStringList): TStringList;
var
  sProtokoll: TStringList;
  ProtokollFName: string;
  n: integer;
  internerTeil: string;
  ParameterNameStart_I: integer;
  ErsterPunktStart_I: integer;
  WertLaengeSoll: integer;
  ParameterName: string;
  Wert: string;
  AusgabeZeile: string;
begin
  result := TStringList.create;
  result.add(ProtokollName + '?');
  ProtokollFName := ProtokollName + '.txt';
  if FileExists(ProtokollFName) then
  begin
    sProtokoll := TStringList.create;
    sProtokoll.LoadFromFile(ProtokollFName);
    result.clear;
    for n := 0 to pred(sProtokoll.count) do
    begin
      internerTeil := nextp(sProtokoll[n], cProtokollStop, 1);
      ParameterNameStart_I := pos(cProtokollVarStart, internerTeil);
      if (ParameterNameStart_I > 0) then
      begin
        ParameterName := copy(internerTeil, ParameterNameStart_I + 1, 2);
        Wert := Ansi2OEM(cutblank(Protokoll.Values[ParameterName]));
        if (Wert <> '') then
        begin

          // Bestimmung der Wert-Länge
          ErsterPunktStart_I := pos('.', internerTeil);
          if (ErsterPunktStart_I = 0) then
            WertLaengeSoll := 1
          else
            WertLaengeSoll := CharCount('.', internerTeil) + 4;

          // Auffüllen des Wertes auf Soll-Länge
          if (length(Wert) <> WertLaengeSoll) then
            Wert := copy(Wert + fill(' ', WertLaengeSoll), 1, WertLaengeSoll);

          // den Wert eintragen
          sProtokoll[n] := copy(sProtokoll[n], 1, pred(ParameterNameStart_I))
            + Wert + copy(sProtokoll[n],
            ParameterNameStart_I + WertLaengeSoll, MaxInt);

        end;
      end;
      AusgabeZeile := cutrblank(OEM2Ansi(nextp(sProtokoll[n], cProtokollStop,
            0)));
      if (AusgabeZeile <> '') then
        if (pos('-', sProtokoll[n]) <> 1) then
          result.add(AusgabeZeile);
    end;
    sProtokoll.free;
  end;
end;

function pem_toHTML(VorlageName, ProtokollName: string;
  Protokoll: TStringList): THTMLTemplate;
var
  sProtokoll: TStringList;
  ProtokollFName: string;
  n: integer;
  internerTeil: string;
  ParameterNameStart_I: integer;
  ErsterPunktStart_I: integer;
  WertLaengeSoll: integer;
  ParameterName: string;
  Wert: string;
  AusgabeZeile: string;

  DatensammlerGlobal: TStringList;
  DatensammlerLokal: TStringList;
  LineNumber: integer;
  Title: string;
begin

  //
  result := THTMLTemplate.create;
  DatensammlerGlobal := TStringList.create;
  DatensammlerLokal := TStringList.create;
  LineNumber := 0;

  result.LoadFromFile(VorlageName);

  with DatensammlerGlobal do
  begin
    add('save&delete BLANK');
    add('save&delete VARIABLE');
    add('save&delete EINGABE');
    add('save&delete TEXT');
    add('save&delete LINE EVEN');
    add('save&delete LINE ODD');
    //
    Title := Protokoll.Values['Titel'];
    if (Title='') then
     Title := ProtokollName;
    add('Titel=' + Title);
  end;

  ProtokollFName := ProtokollName + '.txt';
  if FileExists(ProtokollFName) then
  begin
    sProtokoll := TStringList.create;
    sProtokoll.LoadFromFile(ProtokollFName);
    for n := 0 to pred(sProtokoll.count) do
    begin

      if (pos('-', sProtokoll[n]) = 1) then
      begin
        inc(LineNumber);
        continue;
      end;

      if odd(LineNumber) then
        DatensammlerLokal.add('load LINE ODD,LINE')
      else
        DatensammlerLokal.add('load LINE EVEN,LINE');

      internerTeil := nextp(sProtokoll[n], cProtokollStop, 1);
      ParameterNameStart_I := pos(cProtokollVarStart, internerTeil);
      if (ParameterNameStart_I > 0) then
      begin
        ParameterName := copy(internerTeil, ParameterNameStart_I + 1, 2);

        DatensammlerLokal.add('load BLANK,TEXT');
        DatensammlerLokal.add('load VARIABLE,TEXT');
        DatensammlerLokal.add('Variable=' + ParameterName + '=');

        Wert := cutblank(Protokoll.Values[ParameterName]);
        if (Wert <> '') then
        begin

          // Bestimmung der Wert-Länge
          ErsterPunktStart_I := pos('.', internerTeil);
          if (ErsterPunktStart_I = 0) then
            WertLaengeSoll := 1
          else
            WertLaengeSoll := CharCount('.', internerTeil) + 4;

          // Auffüllen des Wertes auf Soll-Länge
          if (length(Wert) <> WertLaengeSoll) then
            Wert := copy(Wert + fill(' ', WertLaengeSoll), 1, WertLaengeSoll);

          // den Wert eintragen
          DatensammlerLokal.add('load TEXT');
          DatensammlerLokal.add('Text=' + OEM2Ansi(copy(sProtokoll[n], 1,
                pred(ParameterNameStart_I))));
          DatensammlerLokal.add('load EINGABE,TEXT');
          DatensammlerLokal.add('Eingabe=' + Wert);

          // Rest der Zeile
          AusgabeZeile := OEM2Ansi(nextp(copy(sProtokoll[n],
                ParameterNameStart_I + WertLaengeSoll, MaxInt), cProtokollStop,
              0));
          DatensammlerLokal.add('load TEXT');
          DatensammlerLokal.add('Text=' + AusgabeZeile);

        end
        else
        begin
          AusgabeZeile := cutrblank(OEM2Ansi(nextp(sProtokoll[n],
                cProtokollStop, 0)));
          DatensammlerLokal.add('load TEXT');
          DatensammlerLokal.add('Text=' + AusgabeZeile);

        end;
      end
      else
      begin
        DatensammlerLokal.add('load BLANK,TEXT');
        DatensammlerLokal.add('load BLANK,TEXT');
        DatensammlerLokal.add('load BLANK,TEXT');
        DatensammlerLokal.add('load BLANK,TEXT');
        AusgabeZeile := cutrblank(OEM2Ansi(nextp(sProtokoll[n], cProtokollStop,
              0)));
        DatensammlerLokal.add('load TEXT');
        DatensammlerLokal.add('Text=' + AusgabeZeile);
      end;

    end;
    result.WriteValue(DatensammlerLokal, DatensammlerGlobal);

    sProtokoll.free;
    DatensammlerLokal.free;
    DatensammlerGlobal.free;
  end;

end;

end.
