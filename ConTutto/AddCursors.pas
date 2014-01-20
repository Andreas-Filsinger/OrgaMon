unit AddCursors;

interface

const
  crHand = 1;

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, globals;

var
  LoadCursor: HCursor;
  CursorFname: array[0..64] of char;

initialization
  StrPCopy(CursorFname, SystemPath + '\drag.cur');
  if FileExists(CursorFname) then
  begin
    LoadCursor := LoadCursorFromFile(CursorFname); // readonly filemode? AF
    try
      if (LoadCursor = 0) then
        raise Exception.create('Cursor ' + CursorFname + ' not found!');
    finally
      Screen.Cursors[crHand] := LoadCursor;
    end;
  end;
end.
