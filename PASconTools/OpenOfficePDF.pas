{ ================================================================================
  Copyright (C) 1997-2003 Mills Enterprise

  Unit     : OpenOfficePDF
  Purpose  : This unit provides a single class to enabled the programmer to create a PDF
  document through the OpenOffice.Org API.  This unit is provided as freeware
  please use at your own risk.  This file can be found as a part of the rmControls
  library
  Date     : 07-25-2005
  Author   : Ryan J. Mills
  Version  : 1.93
  ================================================================================ }

unit OpenOfficePDF;

interface

uses
  ComObj, Variants, sysutils;

const
  cPDF_Extension = '.pdf';

type
  TOOoWriter = class(TObject)
  private
    fOpenOffice: Variant;
    fDocument: Variant;
    fConnected: boolean;
    fDocumentOpened: boolean;
    fDesktop: Variant;
    fHTMLSrc: boolean;

    function MakePropertyValue(PropName: string; PropValue: Variant): Variant;
  public
    constructor Create;
    destructor Destroy; override;

    function Connect: boolean;
    procedure Disconnect;

    function OpenDocument(Filename: string): boolean;
    procedure SaveToPDF(Filename: string);
    procedure CloseDocument;
  end;

procedure MakePDF(InFileName, OutFileName: string);

implementation

uses
  ActiveX, globals;

{ TOOoWriter }

procedure TOOoWriter.CloseDocument;
begin
  if fDocumentOpened then
  begin
    fDocument.Close(false);

    fDocumentOpened := false;
    fDocument := Unassigned;

    fDesktop.Terminate;
    fDesktop := Unassigned;
  end;
end;

function TOOoWriter.Connect: boolean;
begin
  if VarIsEmpty(fOpenOffice) then
    fOpenOffice := CreateOleObject('com.sun.star.ServiceManager');

  fConnected := not(VarIsEmpty(fOpenOffice) or VarIsNull(fOpenOffice));
  Result := fConnected;
end;

constructor TOOoWriter.Create;
begin
  inherited;
  CoInitialize(nil);
end;

destructor TOOoWriter.Destroy;
begin
  CoUninitialize;
  inherited;
end;

procedure TOOoWriter.Disconnect;
begin
  if fDocumentOpened then
    CloseDocument;

  fConnected := false;
  fOpenOffice := Unassigned;
end;

function TOOoWriter.MakePropertyValue(PropName: string;
  PropValue: Variant): Variant;
var
  Struct: Variant;
begin
  Struct := fOpenOffice.Bridge_GetStruct('com.sun.star.beans.PropertyValue');
  Struct.Name := PropName;
  if VarIsStr(PropValue) then
    PropValue := AnsiString(PropValue);
  Struct.Value := PropValue;
  Result := Struct;
end;

function TOOoWriter.OpenDocument(Filename: string): boolean;
var
  wProperties: Variant;
  wViewSettings: Variant;
  wController: Variant;
begin
  if not fConnected then
    abort;

  fDesktop := fOpenOffice.createInstance('com.sun.star.frame.Desktop');

  wProperties := VarArrayCreate([0, 0], varVariant);
  wProperties[0] := MakePropertyValue('Hidden', True);

  fDocument := fDesktop.loadComponentFromURL
    ('file:///' + StringReplace(Filename, '\', '/', [rfIgnoreCase, rfReplaceAll]
    ), '_blank', 0, wProperties);

  fDocumentOpened := not(VarIsEmpty(fDocument) or VarIsNull(fDocument));

  fHTMLSrc := pos('.htm', lowercase(extractfileext(Filename))) > 0;

  if fDocumentOpened and fHTMLSrc then
  begin
    wController := fDocument.Getcurrentcontroller;
    if not(VarIsEmpty(wController) or VarIsNull(wController)) then
    begin
      wViewSettings := wController.getviewsettings;
      if not(VarIsEmpty(wViewSettings) or VarIsNull(wViewSettings)) then
        wViewSettings.ShowOnlineLayout := false;
    end;
    wViewSettings := Unassigned;
    wController := Unassigned;
  end;

  Result := fDocumentOpened;
end;

procedure TOOoWriter.SaveToPDF(Filename: string);
var
  wProperties: Variant;

begin
  if not(fConnected and fDocumentOpened) then
    abort;

  wProperties := VarArrayCreate([0, 3], varVariant);

  if fHTMLSrc then
    wProperties[0] := MakePropertyValue('FilterName', 'writer_web_pdf_Export')
  else
    wProperties[0] := MakePropertyValue('FilterName', 'writer_pdf_Export');

  wProperties[1] := MakePropertyValue('CompressionMode', '1');
  wProperties[2] := MakePropertyValue('Pages', 'All');
  wProperties[3] := MakePropertyValue('Overwrite', True);

  fDocument.StoreToURL('file:///' + StringReplace(Filename, '\', '/',
    [rfIgnoreCase, rfReplaceAll]), wProperties);
end;

procedure MakePDF(InFileName, OutFileName: string);
var
  wWriter: TOOoWriter;
begin
  if iOpenOfficePDF then
  begin
    wWriter := TOOoWriter.Create;
    try
      if wWriter.Connect then
        try
          if wWriter.OpenDocument(InFileName) then
            try
              wWriter.SaveToPDF(OutFileName);
            finally
              wWriter.CloseDocument;
            end;
        finally
          wWriter.Disconnect;
        end;
    finally
      wWriter.free;
    end;
  end;
end;

end.
