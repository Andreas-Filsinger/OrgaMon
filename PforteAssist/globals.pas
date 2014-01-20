unit globals;

interface

uses
 windows, SysUtils;

const
 Version           : single = 1.013; // ..\rev\PforteAssist.rev.txt
 {
 ArrowOben         : TRect  = (Left:0; Top:0; Right:36; Bottom:8);
 ArrowObenOffset   : TPoint = (x:0; y:-9);
 ArrowUnten        : TRect  = (Left:0; Top:0; Right:36; Bottom:8);
 ArrowUntenOffset  : TPoint = (x:0; y:+27);
 }

 KeyMaxX                    = 11;
 KeyMaxY                    = 3;
 LEDOffsetX                 = 2;
 LEDOffsetY                 = 5;
 SignMaxPoints              = 600;
 DefaultLanguage            = 'de';
 cPossibleLanguages         : array[0..4] of string = ( 'de','es','fr','po','us' );

 iKeyFirstRepeatAfter  : integer   = 900;
 iKeyNextRepeat        : integer   = 99;
 iClearDataAfter       : integer   = 20000;
 iFirstRefreshAfter    : integer   = 20000;

var
 MyProgramPath : string; // <ExePath> + "\"

type
 FlagRecord = record
               TouchRect : TRect;
               ShortName : string[2];
               LongName  : string;
              end;

 KeyRecord  = record
               TouchRect : TRect;
               UpperChar : char;
               LowerChar : char;
              end;

 TCutLight = record
              LEDrect : TRect;
             end;

 TSignPoint = packed record
                      Px,Py : word;
                     end;

 TLampRecord = record
                LampPos : TRect;
                OFFTime : dword;
               end;

 TeAppStatus = (AS_WaitForInput, AS_TextD, AS_TextE );

implementation

initialization
 MyProgramPath := ExtractFilePath(paramstr(0));
end.