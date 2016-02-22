unit TestExec;

{$mode delphi}

interface

uses
  Classes, SysUtils;

procedure RunAsTest;

implementation

uses
  inifiles,
  DCPcrypt2,
  DCPmd5,
  anfix32,
  html,
  infozip,
  txlib,
  CaretakerClient,
  globals;

type
  TTester = class

   (* Oc ist (noch) nicht nötig
   procedure OcTest(Path: string);
   *)
   (* imp pend: OLAP Tests
   procedure OLAPTest(Path: string);
   *)   class procedure htmlTest(Path: string);
    class procedure txLibTest(Path: string);
    class procedure HashTest(Path: string);
    class procedure InfoZIPTest(Path: string);

  end;


(*
procedure TTester.OcTest(Path: string);
var
  sOcSettings: TStringList;
  Content_Mode: Integer;
  FName: string;
begin
  // diese Routine soll später durch add() unnötig werden
  // bzw. die implementierung sollte woanders hin wandern!

  // Beispielhafte Oc Implementierung!
  sOcSettings := TStringList.create;
  if FileExists(Path + 'Test.ini') then
    sOcSettings.LoadFromFile(Path + 'Test.ini');

  Content_Mode := strtointdef(sOcSettings.values['Content_Mode'], -1);
  FName := sOcSettings.values['DateiName'];

  if (Content_Mode > 0) then
    if (FName <> '') then
      OrientationConvert.doConversion(Content_Mode, Path + FName);

  sOcSettings.Free;

end;
*)

class procedure TTester.htmlTest(Path: string);
var
  html: THTMLTemplate;
  Datensammler: TStringList;
begin
  if FileExists(Path + 'WriteValue.txt') then
  begin

    html := THTMLTemplate.Create;
    Datensammler := TStringList.Create;
    html.LoadFromFile(Path + 'Template.html');
    Datensammler.LoadFromFile(Path + 'WriteValue.txt');
    html.writeValue(Datensammler);
    html.SaveToFileCompressed(Path + 'Ergebnis.html');
    html.Free;
    Datensammler.Free;
  end
  else
  begin
    html := THTMLTemplate.Create;
    html.LoadFromFile(Path + 'A.html');
    html.InsertDocument(Path + 'B.html');
    html.SaveToFile(Path + 'Ergebnis.html');
    html.Free;

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

class procedure TTester.infozipTest(Path: string);
const
  cTestArchiveName = 'test.zip';
var
  sTest: TStringList;
  sFiles: TStringList;
  sOptions: TStringList;
begin
  sTest := TStringList.Create;


  sTest.LoadFromFile(Path + 'Test.ini');
  sOptions := anfix32.Split(sTest.values['Options']);
  ersetze('~Path~', Path, sOptions);
  sFiles := anfix32.Split(sTest.values['Files']);
  ersetze('~Path~', Path, sFiles);

  if (sTest.values['Test'] = 'unzip') then
  begin
    unzip(Path + cTestArchiveName, Path, sOptions);
  end
  else
  begin
    zip(sFiles, Path + cTestArchiveName, sOptions);
  end;

  InfoZip.zMessages.SaveToFile(Path + 'Diagnose.txt');

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
      AppendStringsToFile(DCP_md51.FromStrings(MD5s), Path + 'MD5.txt');
      MD5s.Clear;
    end
    else
    begin
      if (BraketLevel = 1) and (LineNo > 1) then
        MD5s.add(#$0D#$0A + sTestData[n])
      else
        MD5s.add(sTestData[n]);
    end;

  end;
  MD5s.Free;
  sTestData.Free;
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
    anfix32.dir(root + '*.', sdir, False, True);
    for n := pred(sdir.Count) downto 0 do
      if pos('.', sdir[n]) = 1 then
        sdir.Delete(n);
    sdir.sort;
  end;

  function FilterTestSource(S: string): string;
  begin
    if pos('size_', S) = 1 then
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
    anfix32.TestMode := True; // suppress timestamps in Result

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
            if (FSize(FullPath + TestSourceFName) <> FSize(FullPath +
              cPath_ErgebnisSoll + sErgebnisseSoll[n])) then
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

        until True;

      end;

    except
      on E: Exception do
      begin
        sDiagnose.add(cERRORText + TestName + '.' + NameSpace + ': ' + E.Message);
      end;
    end;

    anfix32.TestMode := False;

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
    until True;
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
    until True;
  end;

var
  sNameSpaces, sTests: TStringList;
  n, m, o: integer;

begin
  TestMask := GetParam('exec');
  if TestMAsk='' then
   TestMAsk := '*.*';
  iFSPath := 'C:\Users\Andreas\Documents\RAD Studio\Projekte\OrgaMon-fs\';
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

        (*
        if (sNameSpaces[n] = 'Oc') then
        begin
          nTest := OcTest;
          break;
        end;
        if (sNameSpaces[n] = 'infozip') then
        begin
          nTest := infozipTest;
          break;
        end;
        *)

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

        nTest := nil;

      until True;


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

            for o := 0 to pred(sDiagnose.Count) do
              writeln(' ' + sDiagnose[o]);
          end;

      end;
    end;
  end;
  writeln('ENDE');
  sNameSpaces.Free;
  sTests.Free;
  sDiagnose.Free;
end;

end.
