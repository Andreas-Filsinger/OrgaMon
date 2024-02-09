{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2024  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
unit TestExec;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils;

procedure RunAsTest;

implementation

uses
  inifiles,
  DCPcrypt2,
  DCPmd5,
  {$ifdef fpc}
  fpchelper,
  {$endif}
  anfix,
  html,
  c7zip,
  txXML,
  WordIndex,
  OrientationConvert,
  CaretakerClient,
  globals;

type
  TTester = class

    class procedure OcTest(Path: string);
    class procedure OLAPTest(Path: string);
    class procedure htmlTest(Path: string);
    class procedure txLibTest(Path: string);
    class procedure HashTest(Path: string);
    class procedure ZIPTest(Path: string);
    class procedure IndexTest(Path: string);

  end;

class procedure TTester.OLAPTest(Path: string);
begin
  //
end;

class procedure TTester.OcTest(Path: string);
var
  sOcSettings: TStringList;
  Content_Mode: Integer;
  FName: string;

  function StrEndsWith(s,sEnd: String):boolean;
  begin
    result := (RevPos(sEnd,s) = succ(length(s)-length(sEnd)));
  end;

begin

  sOcSettings := TStringList.create;
  if FileExists(Path + 'Test.ini') then
    sOcSettings.LoadFromFile(Path + 'Test.ini');

  Content_Mode := strtointdef(sOcSettings.values['Content_Mode'], -1);
  FName := sOcSettings.values['DateiName'];

  if (Content_Mode > 0) then
    if (FName <> '') then
      OrientationConvert.doConversion(Content_Mode, Path + FName);

  // bei .xls Dateien ist "Soll" und "Ist" niemals
  // vergleichbar da ein TimeStamp und ein Benutzername
  // immer in die .xls geschrieben wird. Deshalb sind
  // die Dateien abhängig vom eingeloggten Benutzer und
  // von der Uhr. Deshalb wird im Fall, dass die
  // Ergebnisdatei eine .xls Datei ist, eine Konvertierung
  // nach .csv nachgeschaltet
  //
  if StrEndsWith(conversionOutFName,'.xls') then
    OrientationConvert.doConversion(Content_Mode_xls2csv, conversionOutFName);

  sOcSettings.Free;
end;


class procedure TTester.htmlTest(Path: string);
var
  mhtml: THTMLTemplate;
  mDatensammler: TStringList;
begin
  if FileExists(Path + 'WriteValue.txt') then
  begin
    mhtml := THTMLTemplate.Create;
    //mhtml.forceUTF8 := true;
    mDatensammler := TStringList.Create;
    mhtml.LoadFromFile(Path + 'Template.html');
    mDatensammler.LoadFromFile(Path + 'WriteValue.txt');
    mhtml.writeValue(mDatensammler);
    mhtml.SaveToFileCompressed(Path + 'Ergebnis.html');
    mDatensammler.Free;
    mhtml.Free;
  end
  else
  begin
    mhtml := THTMLTemplate.Create;
    mhtml.LoadFromFile(Path + 'A.html');
    mhtml.InsertDocument(Path + 'B.html');
    mhtml.SaveToFile(Path + 'Ergebnis.html');
    mhtml.Free;
  end;
end;

class procedure TTester.txlibTest(Path: string);
var
  txlibSettings: TIniFile;
  test: string;

  // TTXStringList testen:
  // - Suchen
  // - Lineare Suche
  // - AVL-Baum-Suche
  // - Hash-Suche
  procedure TestStringList;
  var
    StrList: TTXStringList;
    S: string;

    procedure SearchTest;
    var
      Source: TStringList;
      Dest: TStringList;
      I, C: integer;
    begin
      Source := TStringList.Create;
      Dest := TStringList.Create;

      try
        // Quell-Testdaten laden
        Source.LoadFromFile(Path + 'quelle.txt');

        // TTXStringList mit Testdaten füllen
        C := Source.Count - 1;
        for I := 0 to C do
          StrList.add(Source.Strings[I]);

        // TTXStringList gegen Source testen. Gefundene Suchwerte werden
        // anhand des Index in Dest geschrieben
        C := Source.Count - 1;
        for I := 0 to C do
          Dest.add(IntToStr(StrList.Find(Source.Strings[I])));

        // Gefundene Einträge werden gespeichert
        Dest.SaveToFile(Path + 'ergebnis.txt');
      finally
        Source.Free;
        Dest.Free;
      end;
    end;

  begin
    StrList := TTXStringList.Create;

    try
      with StrList do
      begin
        S := LowerCase(Trim(txlibSettings.ReadString('TTXStringList', 'SearchMethod', '')));
        if S = 'hash' then
          SearchMethod := smHash
        else if S = 'avl' then
          SearchMethod := smAVL
        else
          SearchMethod := smLinear;

        HashSize := txlibSettings.ReadInteger('TTXStringList', 'Hashsize', 1024);
        CaseSensitive := txlibSettings.ReadBool('TTXStringList', 'CaseSensitive', False);
        Trimmed := txlibSettings.ReadBool('TTXStringList', 'Trimmed', False);
        Umlaut := txlibSettings.ReadBool('TTXStringList', 'Umlaut', False);
      end;

      test := LowerCase(Trim(txlibSettings.ReadString('TTXStringList', 'Test', '')));
      if test = 'search' then
        SearchTest;
    finally
      StrList.Free;
    end;
  end;

begin
  txlibSettings := TIniFile.Create(Path + 'Test.ini');
  try
    test := LowerCase(Trim(txlibSettings.ReadString('Global', 'Test', '')));
    if test = 'stringlist' then
      TestStringList;
  finally
    txlibSettings.Free;
  end;
end;

class procedure TTester.zipTest(Path: string);
const
  cTestArchiveName = 'test.zip';
var
  sTest: TStringList;
  sFiles: TStringList;
  sOptions: TStringList;
begin
  sTest := TStringList.Create;


  sTest.LoadFromFile(Path + 'Test.ini');
  sOptions := anfix.Split(sTest.values['Options']);
  ersetze('~Path~', Path, sOptions);
  sFiles := anfix.Split(sTest.values['Files']);
  ersetze('~Path~', Path, sFiles);

  if (sTest.values['Test'] = 'unzip') then
  begin
    unzip(Path + cTestArchiveName, Path, sOptions);
  end
  else
  begin
    zip(sFiles, Path + cTestArchiveName, sOptions);
  end;

  sFiles.Free;
  sOptions.Free;
  sTest.Free;
end;

class procedure TTester.HashTest(Path: string);
var
  sTestData: TStringList;
  MD5s: TStringList;
  DCP_md51: TDCP_md5;
  n: integer;
  BraketLevel: integer;
  LineNo: integer;
begin
  DCP_md51 := TDCP_md5.Create(nil);
  sTestData := TStringList.Create;
  MD5s := TStringList.Create;
  BraketLevel:= 0;
  LineNo:= 0;
  // MD5 Test
  sTestData.LoadFromFile(Path + 'Test-MD5.txt');
  for n := 0 to pred(sTestData.Count) do
  begin

    if BraketLevel = 1 then
      Inc(LineNo);

    if Length(sTestData[n]) = 1 then
    begin
      if pos('{', sTestData[n]) = 1 then
      begin
        Inc(BraketLevel);
        LineNo := 0;
      end;
      if pos('}', sTestData[n]) = 1 then
        Dec(BraketLevel);
    end;

    if (sTestData[n] = '#') then
    begin
      // calculate
      {$ifdef fpc}
      AppendStringsToFile(TDCP_Hash_FromStrings(DCP_md51,MD5s), Path + 'MD5.txt');
      {$else}
      AppendStringsToFile(DCP_md51.FromStrings(MD5s), Path + 'MD5.txt');
      {$endif}
      MD5s.Clear;
    end
    else
    begin
      // add
      if (BraketLevel = 1) and (LineNo > 1) then
        MD5s.add(#$0D#$0A + sTestData[n])
      else
        MD5s.add(sTestData[n]);
    end;

  end;
  MD5s.Free;
  sTestData.Free;
end;

class procedure TTester.IndexTest(Path: string);
var
 SearchWI : TWordIndex;
 Content, Findings: TStringList;
 n, k : Integer;
 RID : Integer;
begin
  SearchWI := TWordIndex.Create(nil, 1);

  // create or just load?
  if FileExists(Path+'Content.csv') then
  begin
    // Dump the coming addwords
    SearchWI.Dump(Path + 'Dump.txt' );

    // load raw content in Textform
    Content := TStringList.create;
    Content.LoadFromFile(Path+'Content.csv');

    // create the index
    for n := 0 to pred(Content.Count) do
    begin
       k := pos(';',Content[n]);
       if (k=0) then
         break;
       RID := StrToIntDef(copy(Content[n], 1, pred(k)), 0);
       if (RID=0) then
         break;
       SearchWI.AddWords(
          {} copy(Content[n], succ(k), MaxInt),
          {} TObject(RID));
    end;
    Content.Free;
    SearchWI.SaveToDiagFile(Path+'Index.csv');
    SearchWI.JoinDuplicates(false);

    // save here for binary check
    SearchWI.SaveToFile(Path + 'Index' + c_wi_FileExtension);
  end else
  begin
    // load the precalculated index
    SearchWI.LoadFromFile(Path + 'Index' + c_wi_FileExtension);
  end;

  if FileExists(Path+'Search.txt') then
  begin
    // testpatterns, search against the index
    Content := TStringList.create;
    Findings := TStringList.create;
    Findings.LoadFromFile(Path+'Search.txt');
    for n := 0 to pred(Findings.Count) do
    begin
      SearchWI.Search(Findings[n]);
      Content.Add(Findings[n]+';'+SearchWI.FoundList.AsString);
    end;
    Content.SaveToFile(Path+'Result.txt');
    Content.Free;
  end;

  SearchWI.free;
end;

procedure RunAsTest;
const
  cPath_ErgebnisSoll = 'Soll-Ergebnis\';
var
  sDiagnose: TStringList;
  nTest: tTestProc;
  FileCompare_UseSize: boolean;
  TestMask: string;

  // Vergleichs-Methoden
  procedure sdir(root: string; sdir: TStringList);
  var
    n: integer;
  begin
    anfix.dir(root + '*.', sdir, False, True);
    for n := pred(sdir.Count) downto 0 do
      if (pos('.', sdir[n]) = 1) then
        sdir.Delete(n);
    sdir.sort;
  end;

  function FilterTestSource(S: string): string;
  begin
    if (pos('size_', S) = 1) then
    begin
      Result := copy(S, 6, MaxInt);
      FileCompare_UseSize := True;
    end
    else
    begin
      Result := S;
      FileCompare_UseSize := False;
    end;
  end;

  procedure SingleTest(NameSpace, TestName: string);
  var
    FullPath: string;
    TestSourceFName: string;
    sErgebnisseSoll: TStringList;
    n: integer;
  begin
    sErgebnisseSoll := TStringList.Create;
    FullPath := iFSPath + NameSpace + '\' + TestName + '\';

    anfix.TestMode := True; // suppress timestamps in Result
    anfix.DebugLogPath := FullPath;

    // den Test durchführen!
    try
      // was gibt es für Ergebnisse?
      dir(FullPath + cPath_ErgebnisSoll + '*', sErgebnisseSoll, False);

      // Imp pend: Wenn es keine Vorgaben gibt muss es
      // einen Selbststest geben!

      // In einem früher ausgeführten Testlauf erstellte Dateien löschen
      for n := 0 to pred(sErgebnisseSoll.Count) do
      begin
        TestSourceFName := FilterTestSource(sErgebnisseSoll[n]);
        if FileExists(FullPath + TestSourceFName) then
          FileDelete(FullPath + TestSourceFName);
      end;

      // der Test an sich!
      nTest(FullPath);

      // Es muss Vorgaben geben,
      if (sErgebnisseSoll.Count = 0) then
        raise Exception.Create('Keine Soll-Ergebnisse in ' + cPath_ErgebnisSoll);

      for n := 0 to pred(sErgebnisseSoll.Count) do
      begin

        TestSourceFName := FilterTestSource(sErgebnisseSoll[n]);
        repeat

          // Datei-Grössen vergleichen
          if FileCompare_UseSize then
          begin
            if (FSize(FullPath + TestSourceFName) <> FSize(FullPath + cPath_ErgebnisSoll +
              sErgebnisseSoll[n])) then
              raise Exception.Create('Grössenunterschiede bei "' + sErgebnisseSoll[n] + '"');
            break;
          end;

          // Ist die Datei überhaupt entstanden?
          if not (FileExists(FullPath + TestSourceFName)) then
            raise Exception.Create('Ergebnisdatei "' + sErgebnisseSoll[n] + '" wurde nicht erzeugt');

          // Datei-Inhalte vergleichen
          if not (FileCompare(FullPath + TestSourceFName, FullPath + cPath_ErgebnisSoll +
            sErgebnisseSoll[n])) then
            raise Exception.Create('Unterschiede bei "' + sErgebnisseSoll[n] + '"');
          break;

        until yet;

      end;

    except
      on E: Exception do
      begin
        sDiagnose.add(cERRORText + TestName + '.' + NameSpace + ': ' + E.Message);
      end;
    end;

    anfix.TestMode := False;

    sErgebnisseSoll.Free;
  end;

  function FilterMatch_NS(NameSpace: string): boolean;
  var
    sFilter: string;
  begin
    Result := True;
    sFilter := nextp(TestMask, '.', 1);
    repeat
      if (sFilter = '*') then
        break;
      if pos(NameSpace, sFilter) > 0 then
        break;
      // Fail
      Result := False;
    until yet;
  end;

  function FilterMatch_Test(NameTest: string): boolean;
  var
    sFilter: string;
  begin
    Result := True;
    sFilter := nextp(TestMask, '.', 0);
    repeat
      if (sFilter = '*') then
        break;
      if pos(NameTest, sFilter) > 0 then
        break;
      // Fail
      Result := False;
    until yet;
  end;

var
  sNameSpaces, sTests: TStringList;
  n, m, o: integer;
  sPath: string;
begin
  TestMask := getParam('test');
  if (TestMask = '') then
    TestMask := '*.*';

  repeat

    sPath := getParam('FSpath');
    if (sPath<>'') then
    begin
     iFSPath := sPath;
     break;
    end;

    if (iFSPath<>'') then
     if DirExists(iFSPath) then
      break;

    iFSPath := 'G:\OrgaMon-FS\';
  until yet;

  // Test starten
  sNameSpaces := TStringList.Create;
  sDiagnose := TStringList.Create;
  sTests := TStringList.Create;
  sdir(iFSPath, sNameSpaces);
  sNameSpaces.sort;
  for n := 0 to pred(sNameSpaces.Count) do
  begin
    if FilterMatch_NS(sNameSpaces[n]) then
    begin

      // setzen der Testmethode!
      repeat

        if (sNameSpaces[n] = 'Oc') then
        begin
          nTest := TTester.OcTest;
          break;
        end;

        if (sNameSpaces[n] = 'OLAP') then
        begin
          nTest := TTester.OLAPTest;
          break;
        end;

        if (sNameSpaces[n] = 'zip') then
        begin
          nTest := TTEster.ZIPTest;
          break;
        end;

        if (sNameSpaces[n] = 'txlib') then
        begin
          nTest := TTester.txlibTest;
          break;
        end;

        if (sNameSpaces[n] = 'Hash') then
        begin
          nTest := TTester.HashTest;
          break;
        end;

        if (sNameSpaces[n] = 'html') then
        begin
          nTest := TTester.htmlTest;
          break;
        end;

        if (sNameSpaces[n] = 'Index') then
        begin
          nTest := TTester.IndexTest;
          break;
        end;

        nTest := nil;

      until yet;


      if assigned(nTest) then
      begin

        sdir(iFSPath + sNameSpaces[n] + '\', sTests);
        sTests.sort;
        for m := 0 to pred(sTests.Count) do
          if FilterMatch_Test(sTests[m]) then
          begin
            sDiagnose.Clear;

            Write(sTests[m] + '.' + sNameSpaces[n] + ' ...');

            // Der Test an sich
            SingleTest(sNameSpaces[n], sTests[m]);

            if (sDiagnose.Count = 0) then
            begin
              writeln(' OK');
            end
            else
            begin
              writeln(cERRORText);
              for o := 0 to pred(sDiagnose.Count) do
                writeln(' ' + sDiagnose[o]);
            end;
          end;

      end;
    end;
  end;
  sNameSpaces.Free;
  sTests.Free;
  sDiagnose.Free;
end;

end.
